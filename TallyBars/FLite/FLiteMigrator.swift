//
//  FLiteMigrator.swift
//  TallyBars
//
//  Created by Daniel Marriner on 07/01/2024.
//

import CoreData

enum FLiteMigrator {
    internal static func migrate(list fliteList: TallyList, into context: NSManagedObjectContext) -> ListModel {
        let id = Int64(fliteList.id!)
        let request = NSFetchRequest<ListModel>(entityName: "ListModel")
        request.predicate = NSPredicate(format: "id = %ld", id)
        let results = try? context.fetch(request)
        if let results, let result = results.first {
            return result
        }

        let list = ListModel(context: context)
        list.id = id
        list.name = fliteList.name

        return list
    }

    internal static func migrate(item fliteItem: TallyItem, into context: NSManagedObjectContext) -> ItemModel {
        let item = ItemModel(context: context)
        item.id = Int64(fliteItem.id!)
        item.name = fliteItem.name
        item.count = Int64(fliteItem.count)

        return item
    }
}
