//
//  APIManager.swift
//  revoultTestApp
//
//  Created by Иван Савин on 08/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation
import Alamofire



struct APIManager {
    
    typealias SuccessBlock = (NSArray)->()
    typealias FailureBlock = (Error?)->()
    
    static let link = "https://revolut.duckdns.org/latest?base=EUR"
    
    static func loadDataWith(success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        Alamofire.request(link).responseJSON { (response) in
            if let error = response.error {
                failure(error)
            } else {
                if let json = response.result.value {
                    print(json)
                }
            }
        }
    }
    
}
