//
//  SingleListView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 03/10/2020.
//

import SwiftUI
import SwiftUICharts

struct SingleListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var list: ListModel

    @State private var selection = 0
    @State private var showsAlert = false

    private var data: ChartData {
        return ChartData(values: list.items.map { item in
            (item.name, item.count)
        })
    }

    private var normalisedData: ChartData {
        let min = list.items.map({ $0.count }).min() ?? 0
        return ChartData(values: list.items.map { item in
            (item.name, item.count - min)
        })
    }

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
                        data: selection == 0 ? data : normalisedData,
                        title: list.name,
                        form: ChartForm.extraLarge,
                        dropShadow: false,
                        cornerImage: Image(systemName: "number"),
                        valueSpecifier: "%.0f"
                    )
                } else {
                    PieChartView(
                        data: data.onlyPoints(),
                        title: list.name,
                        form: ChartForm.extraLarge,
                        dropShadow: false,
                        valueSpecifier: "%.0f"
                    )
                }
            }
            .padding(10)
            
            List {
                ForEach(list.items, id: \.id) { item in
                    SingleItemView(item: item)
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        guard let context = list.managedObjectContext else { return }
                        
                        context.delete(list.items[index])
                        try? context.save()
                    }
                }
            }
        }
        .alert(isPresented: $showsAlert, TextAlert(title: "Title") { title in
            guard let context = list.managedObjectContext else { return }
            guard let title = title, title != "" else { return }

            let item = ItemModel(context: context)
            item.name = title
            item.list = list

            try? context.save()
        })
        .navigationBarTitle(list.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button {
                withAnimation { self.showsAlert = true }
            } label: {
                Image(systemName: "plus")
            }
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                TextField("List Name", text: $list.name) {
                    try? viewContext.save()
                }
                .lineLimit(1)
            }
        }
    }
}
