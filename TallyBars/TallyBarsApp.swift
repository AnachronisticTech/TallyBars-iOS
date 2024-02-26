//
//  TallyBarsApp.swift
//  TallyBars
//
//  Created by Daniel Marriner on 02/10/2020.
//

import SwiftUI
//import FLite
import CoreData
import ATSettingsUI

@main
struct TallyBarsApp: App {
    private let persistenceController = PersistenceController.shared

//    private let store = FLiteStore()
//    @AppStorage("hasPerformedFliteMigration") private var hasMigrated: Bool = false

    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                AllListsView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .environmentObject(themeManager)
            .tint(Color(uiColor: themeManager.auto))
//            .onAppear {
//                guard !hasMigrated else { return }
//
//                try? store.persist.prepare(migration: TallyList.self).wait()
//                try? store.persist.prepare(migration: TallyItem.self).wait()
//
//                let context = persistenceController.container.viewContext
////                if hasMigrated {
////                    for request in [ItemModel.fetchRequest(), ListModel.fetchRequest()] {
////                        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
////
////                        let _ = try? context.execute(batchDelete)
////                    }
////
////                    try? context.save()
////                    hasMigrated = false
////                }
//
//                guard !hasMigrated else { return }
//                print("Migrating data")
//                store.persist
//                    .query(model: TallyList.self)
//                    .with(\.$items)
//                    .all()
//                    .whenSuccess { lists in
//                        for fliteList in lists {
//                            let list = FLiteMigrator.migrate(list: fliteList, into: context)
//                            for fliteItem in fliteList.items {
//                                let item = FLiteMigrator.migrate(item: fliteItem, into: context)
//                                item.list = list
//                            }
//                        }
//
//                        try? context.save()
//                        hasMigrated = true
//                        print("Migration complete")
//                    }
//            }
        }
    }
}
