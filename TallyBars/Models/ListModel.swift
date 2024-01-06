//
//  TallyList.swift
//  TallyBars
//
//  Created by Daniel Marriner on 06/01/2024.
//

import CoreData

@objc(ListModel)
public class ListModel: NSManagedObject, Identifiable {
    @NSManaged public var id: Int64
    @NSManaged public var name: String

    @NSManaged private var pItems: NSSet
    public var items: [ItemModel] {
        return pItems.allObjects as? [ItemModel] ?? []
    }
}
