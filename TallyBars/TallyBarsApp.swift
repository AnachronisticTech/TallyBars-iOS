//
//  TallyBarsApp.swift
//  TallyBars
//
//  Created by Daniel Marriner on 02/10/2020.
//

import SwiftUI
import FLite

class FLiteStore: ObservableObject {
    public var memory = FLite(loggerLabel: "memory-FLITE")
    public var persist = FLite(
        configuration: .file("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")/default.sqlite"),
        loggerLabel: "persisted-FLITE"
    )
}

@main
struct TallyBarsApp: App {
    let store = FLiteStore()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                AllListsView()
                    .environmentObject(store)
            }
            .onAppear {
                try? store.persist.prepare(migration: TallyList.self).wait()
                try? store.persist.prepare(migration: TallyItem.self).wait()
            }
        }
    }
}
