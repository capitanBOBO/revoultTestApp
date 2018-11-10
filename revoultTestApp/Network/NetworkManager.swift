//
//  APIManager.swift
//  revoultTestApp
//
//  Created by Иван Савин on 08/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation
import Alamofire

struct DataStruct {
    var currencyName: String
    var currencyRate: Float
    
    init(currencyName: String, currencyRate: Float) {
        self.currencyName = currencyName;
        self.currencyRate = currencyRate;
    }
}

typealias SuccessBlock = ([DataStruct])->()
typealias FailureBlock = (Error?)->()

class NetworkManager:NSObject {
    
    var link = "https://revolut.duckdns.org/latest?base="
    
    func loadData(forCurrency currency:String = "EUR", success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        let fullPath = link + currency
        Alamofire.request(fullPath).responseJSON { (response) in
            if let error = response.error {
                failure(error)
            } else {
                if let jsonDictionary = response.result.value as? [String:Any] {
                    var retArray:[DataStruct] = []
                    if let base = jsonDictionary["base"] as? String {
                        retArray.append(DataStruct(currencyName: base, currencyRate: 1))
                    }
                    if let rates = jsonDictionary["rates"] as? [String:Any] {
                        for rate in rates {
                            if let (name, value) = (rate.key, rate.value) as? (String, NSNumber) {
                                retArray.append(DataStruct(currencyName: name, currencyRate: value.floatValue))
                            }
                        }
                    }
                    success(retArray)
                }
            }
        }
    }
}

