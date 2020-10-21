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
    @State private var showsAlert = false
    @State var list: TallyList
    @State var selection = 0
    @ObservedObject var itemProvider = ListProvider()

    var body: some View {
        VStack {
            Picker(selection: $selection, label: Text("Mode")) {
                Text("Full").tag(0)
                Text("Normalised").tag(1)
                Text("Pie").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.leading, .trailing, .top], 10)
            Group {
                if selection != 2 {
                    UBarChartView(
                        data: selection == 0 ? itemProvider.data : itemProvider.normalisedData,
                        title: list.name,
                        form: ChartForm.extraLarge,
                        dropShadow: false,
                        cornerImage: Image(systemName: "number"),
                        valueSpecifier: "%.0f"
                    )
                } else {
                    PieChartView(
                        data: itemProvider.data.onlyPoints(),
                        title: list.name,
                        form: ChartForm.extraLarge,
                        dropShadow: false,
                        valueSpecifier: "%.0f"
                    )
                }
            }
            .padding(10)
            List {
                ForEach(itemProvider.items, id: \.id) { item in
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
                                itemProvider.updateItems(from: list, in: store)
                            }
                    }
                    .onLongPressGesture {
                        item.count -= 1
                        store.persist
                            .update(model: item)
                            .whenSuccess {
                                itemProvider.updateItems(from: list, in: store)
                            }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        itemProvider.deleteItem(at: index, in: store)
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
                    itemProvider.updateItems(from: list, in: store)
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
            itemProvider.updateItems(from: list, in: store)
        }
    }
}
