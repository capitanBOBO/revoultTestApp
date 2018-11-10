//
//  ViewModel.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation

class ViewModel: ViewModelType {
    
    private var networkManager = NetworkManager()
    private var currencyArray = [DataStruct]()
    private var notificator:NotificationBlock?
    private var curretnCurrency = "EUR"
    
    func startDataUpdatingWith(_ notify: @escaping NotificationBlock) {
        notificator = notify
        Timer.scheduledTimer(withTimeInterval: 1,
                             repeats: true) { [weak self] (timer) in
                                if let weakSelf = self {
                                    weakSelf.loadData()
                                }
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
        curretnCurrency = currencyArray[indexPath.row].currencyName
    }
    
    private func loadData() {
        networkManager.loadData(forCurrency: curretnCurrency, success: { [unowned self] (array) in
            self.currencyArray = array
            if let notification = self.notificator {
                notification()
            }
        }) { (error) in
            print(error!)
        }
    }
        
}
