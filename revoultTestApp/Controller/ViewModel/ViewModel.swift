//
//  ViewModel.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation

protocol ViewModelDelegate:class {
    func update()
}

class ViewModel: ViewModelType, DataManagerDelegate {
    
    private var networkManager = NetworkManager()
    private var dataManager = DataManager()
    private var currencyArray = [Currency]()
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
    
    func countOfRows() -> Int {
        return currencyArray.count
    }
    
    func cellViewModelFor(_ indexPath: IndexPath) -> CellViewModel? {
        guard currencyArray.count >= indexPath.row + 1 else {
            return nil
        }
        return CellViewModel(currency: currencyArray[indexPath.row])
    }
    
    func didSelectCurrencyAt(_ indexPath: IndexPath) {
        guard currencyArray.count >= indexPath.row + 1 else {
            return
        }
        updateAllRows = true
        curretnCurrency = currencyArray[indexPath.row].name ?? ""
    }
    
    func rowsForUpdate() -> [IndexPath] {
        var retArray = [IndexPath]()
        for index in 0...self.currencyArray.count {
            if !updateAllRows {
                continue
            } else {
                retArray.append(IndexPath(row: index, section: 0))
            }
        }
        updateAllRows = false
        return retArray
    }
    
    func dataWasUpdated() {
        if let delegate = delegate {
            if let currencies = dataManager.loadCurrency() {
                self.currencyArray = currencies
                delegate.update()                
            }
        }
    }
}
