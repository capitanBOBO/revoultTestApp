//
//  CellViewModel.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation

class CellViewModel: CellViewModelType {
    
    private var currency:DataStruct
    var currencyName:String {
        get {
            return currency.currencyName
        }
    }
    var currencyValue:String {
        get {
            return "\(currency.currencyRate)"
        }
    }
    
    init(currency:DataStruct) {
        self.currency = currency
    }
    
}
