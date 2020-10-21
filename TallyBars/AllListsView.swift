//
//  AllListsView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 02/10/2020.
//

import SwiftUI
import FLite
import Later

struct AllListsView: View {
    @EnvironmentObject var store: FLiteStore
    @State private var items = [TallyList]()
    @State private var showsAlert = false

    var body: some View {
        List {
            ForEach(items, id: \.id) { item in
                VStack {
                    NavigationLink(
                        item.name,
                        destination: SingleListView(list: item)
                            .environmentObject(store)
                    )
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    store.persist
                        .delete(model: items[index])
                        .whenSuccess { items.remove(at: index) }
                }
            }
        }
        .listStyle(PlainListStyle())
        .alert(isPresented: $showsAlert, TextAlert(title: "Title") { title in
            guard let title = title, title != "" else { return }
            store.persist
                .add(model: TallyList(name: title))
                .flatMap { _ in store.persist.all(model: TallyList.self) }
                .whenSuccess { items = $0 }
        })
        .navigationBarTitle("Lists")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(
            trailing: Button(action: {
                withAnimation { self.showsAlert = true }
            }) { Image(systemName: "plus") }
        )
        .onAppear {
            store.persist
                .all(model: TallyList.self)
                .whenSuccess { items = $0 }
        }
    }
}
