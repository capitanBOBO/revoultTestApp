//
//  ViewModel.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation

protocol ViewModelDelegate:class {
//    func update()
    func beginUpdate()
    func endUpdate()
}

class ViewModel: ViewModelType, DataManagerDelegate {
    
    private var networkManager = NetworkManager()
    private var dataManager = DataManager()
    private var currencyArray = [Currency]()
    private var baseCurrency:Currency?
    private var curretnCurrency = "EUR"
    private var updateAllRows = true
    
    weak var delegate:ViewModelDelegate?
    
    init() {
        dataManager.delegate = self
    }
    
    func startDataUpdating() {
        Timer.scheduledTimer(withTimeInterval: 1,
                             repeats: true) { [unowned self] (timer) in
                                self.networkManager.loadData(forCurrency: self.curretnCurrency)
        }
    }
    
    func countOfRowsFor(_ section: Int) -> Int {
        if section == 0 {
            return baseCurrency == nil ? 0 : 1
        } else {
            return currencyArray.count
        }
    }
    
    func cellViewModelFor(_ indexPath: IndexPath) -> CellViewModel? {
        if indexPath.section == 0  {
            if let baseCurrency = baseCurrency {
                return CellViewModel(currency: baseCurrency)
            } else {
                return nil
            }
        } else {
            if currencyArray.count >= indexPath.row + 1 {
                return CellViewModel(currency: currencyArray[indexPath.row])
            } else {
                return nil
            }
        }
    }
    
    func didSelectCurrencyAt(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        guard currencyArray.count >= indexPath.row + 1 else {
            return
        }
        updateAllRows = true
        curretnCurrency = currencyArray[indexPath.row].name ?? ""
    }
    
    func sectionsForUpdate() -> IndexSet {
        if updateAllRows {
            updateAllRows = false
            return IndexSet(arrayLiteral: 0, 1)
        } else {
            return IndexSet(arrayLiteral: 1)
        }
        
    }
    
    func dataWasUpdated() {
        if let delegate = delegate {
            if let currencies = dataManager.loadCurrency() {
                currencyArray.removeAll()
                delegate.beginUpdate()
                for currency in currencies {
                    if currency.isBase {
                        baseCurrency = currency
                    } else {
                        currencyArray.append(currency)
                    }
                }
                delegate.endUpdate()
            }
        }
    }
}
