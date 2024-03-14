//
//  TallyBarsApp.swift
//  TallyBars
//
//  Created by Daniel Marriner on 02/10/2020.
//

import SwiftUI
//import FLite
import CoreData
import ATCommon
import ATiOS

@main
struct TallyBarsApp: App {
//    @UIApplicationDelegateAdaptor var delegate: AppDelegate

    private let persistenceController = PersistenceController.shared

//    private let store = FLiteStore()
//    @AppStorage("hasPerformedFliteMigration") private var hasMigrated: Bool = false

    @StateObject private var appIconManager = AppIconManager(PrimaryAppIcon(), alternatives: [], Logger.shared)
    @StateObject private var crossPromoAppsManager = CrossPromoAppsManager(appIdentifier: Bundle.main.bundleIdentifier, showAllApps: true)
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var store = Store(
        donationIds: [
            "com.anachronistictech.smalltip",
            "com.anachronistictech.mediumtip",
            "com.anachronistictech.largetip"
        ],
        Logger.shared
    )

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AllListsView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .environment(\.logger, Logger.shared)
            .environment(\.appIconManager, appIconManager)
            .environment(\.crossPromoAppsManager, crossPromoAppsManager)
            .environment(\.themeManager, themeManager)
            .environment(\.store, store)
            .tint(themeManager.accentColor)
            .preferredColorScheme(themeManager.scheme)
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

//class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        Utils.logger.log(.notice, message: "launched")
//
//        return true
//    }
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
//        sceneConfig.delegateClass = SceneDelegate.self
//        return sceneConfig
//    }
//}
//
//class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
//    var window: UIWindow?
//
//    func sceneDidBecomeActive(_ scene: UIScene) {
//        Utils.logger.log(.notice, message: "scene active")
//    }
//    
//    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
//        Utils.logger.log(.notice, message: "traits: \(previousTraitCollection)")
//    }
//}
