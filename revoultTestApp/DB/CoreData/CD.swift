//
//  CD.swift
//  revoultTestApp
//
//  Created by Иван Савин on 11/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation
import CoreData

class CD {
    
    static let shared = CD()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "revoultTestApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext:NSManagedObjectContext = {
        let moc = persistentContainer.viewContext
        return moc
    }()
    
    func saveContext () {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
