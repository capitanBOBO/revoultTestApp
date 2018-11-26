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
    func updateCurrenciesListAt(_ indexPaths: [IndexPath]?)
    func updateError(_ errorDescription: String)
}

class ViewModel: ViewModelType, DataManagerDelegate {
    
    var firstLoad = true
    private var dataManager = DataManager()
    private var currencyArray = [Currency]()
    private var curretnBaseCurrency = "EUR"
    
    weak var delegate: ViewModelDelegate?
    
    init() {
        dataManager.delegate = self
        if let baseCurrency = dataManager.loadBaseCurrency() {
            curretnBaseCurrency = baseCurrency.name
        }
    }
    
    func downloadData() {
        dataManager.downloadData()
    }
    
    func countOfRows() -> Int {
        return currencyArray.count
    }
    
    func cellViewModelFor(_ indexPath: IndexPath) -> CellViewModel? {
        if let currency = currencyArray[indexPath.row] as Currency? {
            return CellViewModel(currency: currency)
        }
        return nil
    }
    
    func dataWasUpdated(_ updatedData: [Currency]) {
        if currencyArray.isEmpty {
            if let tempArray = dataManager.loadCurrency() {
                currencyArray = Array(tempArray)
                delegate?.updateCurrenciesListAt(nil)
            }
        } else {
            var indexPaths = [IndexPath]()
            for updatedCurrency in updatedData {
                guard let currentCurrency = currencyArray.first(where: {$0.name == updatedCurrency.name}) else {
                    continue
                }
                guard let index = currencyArray.firstIndex(of: currentCurrency) else {
                    continue
                }
                indexPaths.append(IndexPath(row: index, section: 0))
//                if currency.isBase {
//                    indexPaths.append(IndexPath(row: 0, section: 0))
//                    if let index = currencyArray.firstIndex(of: currency) {
//                        indexPaths.append(IndexPath(row: index, section: 0))
//                    }
//                }
            }
            delegate?.updateCurrenciesListAt(indexPaths)
        }
        
    }
    
    func dataUpdateError(_ errorDescription: String) {
        delegate?.updateError(errorDescription)
    }
}
