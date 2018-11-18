//
//  ViewModel.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation

typealias ViewModeUpdateBlock = ()->()

protocol ViewModelDelegate:class {
    func updateCurrenciesList(isNeedUpdateBaseCurrency:Bool)
}

class ViewModel: ViewModelType, DataManagerDelegate {
    
    var firstLoad = true
    private var networkManager = NetworkManager()
    private var dataManager = DataManager()
    private var currencyArray = [Currency]()
    private var curretnCurrency = "EUR"
    
    weak var delegate: ViewModelDelegate?
    
    init() {
        dataManager.delegate = self
        if let baseCurrency = dataManager.loadBaseCurrency() {
            curretnCurrency = baseCurrency.name!
        }
    }
    
    func startDataUpdating() {
        Timer.scheduledTimer(withTimeInterval: 1,
                             repeats: true) { [unowned self] (timer) in
                                self.networkManager.loadData(forCurrency: self.curretnCurrency)
        }
    }
    
    func countOfRowsFor(_ section: Int) -> Int {
        if section == 0 {
            return currencyArray.count == 0 ? 0 : 1
        } else {
            return currencyArray.count - 1
        }
    }
    
    func cellViewModelFor(_ indexPath: IndexPath) -> CellViewModel? {
        if indexPath.section == 0  {
            if let currency = currencyArray.first {
                return CellViewModel(currency: currency)
            }
        } else {
            if let currency = currencyArray[indexPath.row + 1] as Currency? {
                return CellViewModel(currency: currency)
            }
        }
        return nil
    }
    
    func didSelectCurrencyAt(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        if let currency = currencyArray[indexPath.row + 1] as Currency? {
            curretnCurrency = currency.name ?? ""
        }
    }
    
    func dataWasUpdated() {
        if let delegate = delegate {
            guard let currencies = dataManager.loadCurrency() else {
                return
            }
            if currencyArray.count == 0 {
                self.currencyArray = currencies
                delegate.updateCurrenciesList(isNeedUpdateBaseCurrency: true)
            } else {
                if let currency = currencyArray.first, currency.isBase == false {
                    currencyArray = currencies
                    delegate.updateCurrenciesList(isNeedUpdateBaseCurrency: true)
                } else {
                    delegate.updateCurrenciesList(isNeedUpdateBaseCurrency: false)
                }
            }
            
        }
    }
}
