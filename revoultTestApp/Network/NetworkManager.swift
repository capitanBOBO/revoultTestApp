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
    
    private var dataManager = DataManager()
    
    func loadData(forCurrency currency:String = "EUR") {
        let fullPath = "https://revolut.duckdns.org/latest?base=" + currency
        Alamofire.request(fullPath).responseJSON { [weak self] (response) in
            if let error = response.error {
                print(error)
            } else {
                if let jsonDictionary = response.result.value as? [String:Any] {
                    self?.dataManager.saveCurrenciesFrom(jsonDictionary)
                }
            }
        }
    }
}

