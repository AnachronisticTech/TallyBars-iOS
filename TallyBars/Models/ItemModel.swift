//
//  TallyItem.swift
//  
//
//  Created by Daniel Marriner on 06/01/2024.
//

import CoreData

@objc(ItemModel)
public class ItemModel: NSManagedObject, Identifiable {
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var count: Int64
    @NSManaged public var list: ListModel
}
