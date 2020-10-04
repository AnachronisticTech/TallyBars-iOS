//
//  SingleListView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 03/10/2020.
//

import SwiftUI

struct SingleListView: View {
    @EnvironmentObject var store: FLiteStore
    @State private var items: [TallyItem] = []
    @State private var showsAlert = false
    @State var list: TallyList

    var body: some View {
        VStack {
            TextField("List Name", text: $list.name, onCommit: {
                let _ = store.persist.update(model: list)
            })
            .lineLimit(1)
            List {
                ForEach(items, id: \.id) { item in
                    VStack {
                        Text(item.name)
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
            .alert(isPresented: $showsAlert, TextAlert(title: "Title") { title in
                guard let title = title, title != "" else { return }
                store.persist
                    .add(model: TallyItem(listId: list.id!, name: title))
                    .flatMap { _ in store.persist.all(model: TallyItem.self) }
                    .whenSuccess { _ in
                        list.$items
                            .query(on: store.persist.query(model: TallyItem.self).database)
                            .with(\.$list)
                            .all()
                            .whenSuccess { items = $0 }
                    }
            })
            .navigationBarTitle(list.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    withAnimation { self.showsAlert = true }
                }) { Image(systemName: "plus") }
            )
            .onAppear {
                list.$items
                    .query(on: store.persist.query(model: TallyItem.self).database)
                    .with(\.$list)
                    .all()
                    .whenSuccess { items = $0 }
            }
        }
    }
}
