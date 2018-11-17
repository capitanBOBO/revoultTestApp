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
    func dataWasUpdated()
}

class DataManager:NSObject {
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: CD.shared.privateMoc)
    }
    
    deinit {
        
    }
    
    weak var delegate:DataManagerDelegate?
    
    // MARK: - Core Data Saving support
    
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
    
    func saveCurrenciesFrom(_ dictionary: [String:Any]) {
        DispatchQueue.global().async {
            if let (base, rates) = (dictionary["base"], dictionary["rates"]) as? (String, [String:Any]) {
                var baseCurrencyValue:Float = 1.0
                if let baseCurrency = self.loadCurrency(for: base)?.first {
                    baseCurrency.isBase = true
                    baseCurrencyValue = baseCurrency.value
                } else {
                    let baseCurrency = Currency(context: CD.shared.managedObjectContext)
                    baseCurrency.isBase = true
                    baseCurrency.name = base
                    baseCurrency.value = 1.0
                }
                for rate in rates {
                    if let (name, value) = (rate.key, rate.value) as? (String, NSNumber) {
                        if let currentStateCurrency = self.loadCurrency(for: name)?.first {
                            currentStateCurrency.isBase = false
                            currentStateCurrency.value = baseCurrencyValue * value.floatValue
                        } else {
                            let currency = Currency(context: CD.shared.managedObjectContext)
                            currency.isBase = false
                            currency.name = name
                            currency.value = baseCurrencyValue * value.floatValue
                        }
                    }
                }
                CD.shared.saveContext()
            }
        }
    }
    
    @objc private func contextDidSave(_ notification: Notification) {
        DispatchQueue.main.async {
            CD.shared.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            if let delegate = self.delegate {
                delegate.dataWasUpdated()
            }
        }
    }
    
}
