//
//  DataManager.swift
//  revoultTestApp
//
//  Created by Иван Савин on 11/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation
import CoreData

protocol DataManagerDelegate: class {
    func dataWasUpdated(_ updatedData: [Currency])
    func dataUpdateError(_ errorDescription: String)
}

class DataManager:NSObject {
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidUpdate), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: CD.shared.backgroundCotext)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    weak var delegate:DataManagerDelegate?
    
    private lazy var baseCurrencyName:String = {
        let currency = "EUR"
        return currency
    }()
    
    private let networkManager = NetworkManager()
    
    func downloadData() {
        if let baseCurrency = self.loadBaseCurrency() {
            baseCurrencyName = baseCurrency.name
        }
        networkManager.loadData(forCurrency: baseCurrencyName, success: { [weak self] (result) in
            self?.saveCurrenciesFrom(result)
            }, failure: { [weak self] (error) in
                self?.delegate?.dataUpdateError(error.localizedDescription)
        })
    }
    
    private func saveCurrenciesFrom(_ dictionary: [String:Any]) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            if let (base, rates) = (dictionary["base"], dictionary["rates"]) as? (String, [String:Any]) {
                var baseCurrencyValue:Float = 1.0
                if let baseCurrency = self?.loadBaseCurrency() {
                    if baseCurrency.name == base {
                        baseCurrencyValue = baseCurrency.value
                    }
                } else {
                    let baseCurrency = Currency(context: CD.shared.managedObjectContext)
                    baseCurrency.isBase = true
                    baseCurrency.name = base
                    baseCurrency.value = 1.0
                    baseCurrency.rate = 1.0
                }
                for rate in rates {
                    if let (name, rate) = (rate.key, rate.value) as? (String, NSNumber) {
                        if let currentStateCurrency = self?.loadCurrency(for: name)?.first {
                            currentStateCurrency.isBase = false
                            currentStateCurrency.value = baseCurrencyValue * rate.floatValue
                            currentStateCurrency.rate = rate.floatValue
                        } else {
                            let currency = Currency(context: CD.shared.managedObjectContext)
                            currency.isBase = false
                            currency.name = name
                            currency.value = baseCurrencyValue * rate.floatValue
                            currency.rate = rate.floatValue
                        }
                    }
                }
                CD.shared.saveContext()
            }
        }
    }
    
    func loadCurrency(for name:String? = nil) -> [Currency]? {
        let currencyFetch = Currency.fetchRequest() as NSFetchRequest<Currency>
        if let name = name {
            currencyFetch.predicate = NSPredicate(format: "name = %@", name)
        }
        currencyFetch.sortDescriptors = [NSSortDescriptor.init(key: "isBase", ascending: false)]
        if let currencies = try? CD.shared.managedObjectContext.fetch(currencyFetch) {
            return currencies
        } else {
            print("Load data failure")
            return nil
        }
    }
    
    func loadBaseCurrency() -> Currency? {
        let currencyFetch = Currency.fetchRequest() as NSFetchRequest<Currency>
        currencyFetch.predicate = NSPredicate(format: "isBase = %@", NSNumber.init(value: true))
        if let currencies = try? CD.shared.managedObjectContext.fetch(currencyFetch) {
            return currencies.first
        } else {
            print("Load data failure")
            return nil
        }
    }
    
    func updateBaseCurrency(value: Float) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let currencies = self?.loadCurrency() {
                for currency in currencies {
                    if currency.isBase {
                        currency.value = value
                    } else {
                        currency.value = currency.rate * value
                    }
                }
                CD.shared.saveContext()
            }
        }
    }
    
    func setCurrencyAsBase(_ name: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let currencies = self?.loadCurrency() else {
                return
            }
            if let oldBase = currencies.filter({$0.isBase}).first,
                let newBase = currencies.filter({$0.name == name}).first {
                oldBase.isBase = false
                newBase.isBase = true
                newBase.rate = 1.0
                CD.shared.saveContext()
            }
        }
    }
    
    @objc private func contextDidUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<Currency>, inserts.count > 0 {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.dataWasUpdated(Array(inserts).sorted(by: {$1.isBase}))
            }
        } else if let updates = userInfo[NSUpdatedObjectsKey] as? Set<Currency>, updates.count > 0 {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.dataWasUpdated(Array(updates))
            }
        }
    }
}
