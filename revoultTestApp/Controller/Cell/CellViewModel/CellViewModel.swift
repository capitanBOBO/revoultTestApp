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
    private var dataManager = DataManager()
    
    var currencyName:String {
        get {
            return currency.name
        }
    }
    var currencyValue:String {
        get {
            return String(format: "%.3f", currency.value)
        }
    }
    
    var isBaseCurrency:Bool {
        get {
            return currency.isBase
        }
    }
    
    init(currency:Currency) {
        self.currency = currency
    }
    
    func changeCurrencyValueOn(_ value: Float) {
        dataManager.updateBaseCurrency(value: value)
    }
    
    func setCurrencyAsBase() {
        dataManager.setCurrencyAsBase(currency.name)
    }
    
}
