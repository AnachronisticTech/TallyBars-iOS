//
//  SingleListView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 03/10/2020.
//

import SwiftUI
import SwiftUICharts
import Charts
import CoreData

struct SingleListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var list: ListModel

    @State private var selection = ChartType.standard
    @State private var isAddingNewItem = false
    @State private var newItemName = ""

    private var minimumCount: Int64 {
        return switch selection {
            case .normalized: items.map({ $0.count }).min() ?? 0
            default: 0
        }
    }

    private var data: ChartData {
        let min = minimumCount
        return ChartData(values: items.map { item in
            (item.name, item.count - min)
        })
    }

    private var request: FetchRequest<ItemModel>
    private var items: FetchedResults<ItemModel> {
        request.wrappedValue
    }

    init(list: ListModel) {
        self.list = list
        request = FetchRequest<ItemModel>(
            entity: ItemModel.entity(),
            sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)],
            predicate: NSPredicate(format: "list.id = %ld", list.id)
        )
    }

    var body: some View {
        VStack {
            if items.count > 1 {
                Picker(selection: $selection, label: Text("Mode")) {
                    Text("Full").tag(ChartType.standard)
                    if items.count > 2 && Set(list.items.map({ $0.count })).count > 1 {
                        Text("Normalised").tag(ChartType.normalized)
                    }
                    Text("Pie").tag(ChartType.pie)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing, .top], 10)
            }

            Group {
                if selection == .standard || selection == .normalized {
                    Chart {
                        ForEach(items) { item in
                            BarMark(
                                x: .value(list.name, item.name),
                                y: .value("Count", item.count - minimumCount)
                            )
                        }
                    }
                } else if selection == .pie {
                    if #available(iOS 17, *) {
                        Chart {
                            ForEach(items) { item in
                                SectorMark(angle: .value(list.name, item.count))
                            }
                        }
                    } else {
                        PieChartView(
                            data: data.onlyPoints(),
                            title: list.name,
                            form: ChartForm.extraLarge,
                            dropShadow: false,
                            valueSpecifier: "%.0f"
                        )
                    }
                } else {
                    Text("Char type not implemented")
                }
            }
            .padding(10)

            List {
                ForEach(items, id: \.id) { item in
                    SingleItemView(item: item)
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        guard let context = list.managedObjectContext else { return }

                        context.delete(list.items[index])
                        saveContext(context)
                    }
                }

                AddNewItemView(newItemName: $newItemName, isAddingNewItem: $isAddingNewItem, action: addNewItem)
            }
            .listStyle(.plain)
        }
        .navigationBarTitle(list.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                TextField("List Name", text: $list.name) {
                    guard let context = list.managedObjectContext else { return }
                    saveContext(context)
                }
                .lineLimit(1)
            }
        }
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    private func addNewItem() {
        guard let context = list.managedObjectContext else { return }
        guard let lastId = list.items.isEmpty ? 0 : list.items.map({ $0.id }).max() else { return }
        guard newItemName != "" else { return }

        isAddingNewItem = false

        let item = ItemModel(context: context)
        item.id = Int64(lastId + 1)
        item.name = newItemName
        item.list = list

        saveContext(context)
        newItemName = ""
    }

    private enum ChartType {
        case standard, normalized, pie
    }
}
