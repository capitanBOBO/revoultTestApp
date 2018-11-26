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
    private var baseCurrency:Currency!
    
    weak var delegate: ViewModelDelegate?
    
    init() {
        dataManager.delegate = self
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
        if let tempArray = dataManager.loadCurrency() {
            currencyArray = Array(tempArray)
        }
        if baseCurrency == nil {
            baseCurrency = currencyArray.first(where: {$0.isBase})
            delegate?.updateCurrenciesListAt(nil)
            return
        }
        var indexPaths = [IndexPath]()
        for (index, _) in currencyArray.filter({!$0.isBase}).enumerated() {
            indexPaths.append(IndexPath(row: index + 1, section: 0))
        }
        if let base = currencyArray.first(where: {$0.isBase}) {
            if base.name != baseCurrency.name {
                indexPaths.append(IndexPath(row: 0, section: 0))
                baseCurrency = base
            }
        }
        delegate?.updateCurrenciesListAt(indexPaths)
    }
    
    func dataUpdateError(_ errorDescription: String) {
        delegate?.updateError(errorDescription)
    }
}
