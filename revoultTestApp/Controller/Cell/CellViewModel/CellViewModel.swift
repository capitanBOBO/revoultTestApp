//
//  CellViewModel.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation

class CellViewModel: CellViewModelType {
    
    private var currency:Currency
    var currencyName:String {
        get {
            return currency.name ?? ""
        }
    }
    var currencyValue:String {
        get {
            return "\(currency.value)"
        }
    }
    
    init(currency:Currency) {
        self.currency = currency
    }
    
    func updateCurrencyWith(_ value: Float) {
        currency.value = value
        CD.shared.saveContext()
    }
    
}
