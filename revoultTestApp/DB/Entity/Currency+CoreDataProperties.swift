//
//  Currency+CoreDataProperties.swift
//  
//
//  Created by Иван Савин on 11/11/2018.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var value: Float
    @NSManaged public var isBase: Bool
    
}
