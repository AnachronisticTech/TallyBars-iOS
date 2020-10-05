//
//  SingleListView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 03/10/2020.
//

import SwiftUI
import SwiftUICharts

struct SingleListView: View {
    @EnvironmentObject var store: FLiteStore
    @State private var items = [TallyItem]()
    @State private var showsAlert = false
    @State var list: TallyList

    var body: some View {
        VStack {
            BarChartView(
                data: ChartData(values: items.map { ($0.name, $0.count) }),
                title: list.name,
                form: ChartForm.extraLarge
            )
            .padding(10)
            List {
                ForEach(items, id: \.id) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.count)")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        item.count += 1
                        store.persist
                            .update(model: item)
                            .whenSuccess {
                                list.$items
                                    .query(on: store.persist.query(model: TallyItem.self).database)
                                    .with(\.$list)
                                    .all()
                                    .whenSuccess { items = $0 }
                            }
                    }
                    .onLongPressGesture {
                        item.count -= 1
                        store.persist
                            .update(model: item)
                            .whenSuccess {
                                list.$items
                                    .query(on: store.persist.query(model: TallyItem.self).database)
                                    .with(\.$list)
                                    .all()
                                    .whenSuccess { items = $0 }
                            }
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                TextField("List Name", text: $list.name, onCommit: {
                    let _ = store.persist.update(model: list)
                }).lineLimit(1)
            }
        }
        .onAppear {
            list.$items
                .query(on: store.persist.query(model: TallyItem.self).database)
                .with(\.$list)
                .all()
                .whenSuccess { items = $0 }
        }
    }
}
