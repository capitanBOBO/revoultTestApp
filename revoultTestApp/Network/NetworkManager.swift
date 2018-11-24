//
//  APIManager.swift
//  revoultTestApp
//
//  Created by Иван Савин on 08/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager:NSObject {
    
    typealias Success = ([String:Any])->()
    typealias Failure = (Error)->()
    
    func loadData(forCurrency currency:String = "EUR", success:Success? = nil, failure:Failure? = nil) {
        let fullPath = "https://revolut.duckdns.org/latest?base=" + currency
        Alamofire.request(fullPath).responseJSON { (response) in
            if let error = response.error {
                if let failure = failure {
                    failure(error)
                }
            } else {
                if let jsonDictionary = response.result.value as? [String:Any] {
                    if let success = success {
                        success(jsonDictionary)
                    }
                }
            }
        }
    }
}

