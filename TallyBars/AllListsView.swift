//
//  AllListsView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 02/10/2020.
//

import SwiftUI
import CoreData

struct AllListsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAddingNewItem = false
    @State private var newItemName = ""

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ListModel.id, ascending: true)]) private var lists: FetchedResults<ListModel>

    var body: some View {
        List {
            ForEach(lists, id: \.id) { item in
                VStack {
                    NavigationLink(
                        item.name,
                        destination: SingleListView(list: item)
                            .environment(\.managedObjectContext, viewContext)
                    )
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    viewContext.delete(lists[index])
                    try? viewContext.save()
                }
            }

            AddNewItemView(newItemName: $newItemName, isAddingNewItem: $isAddingNewItem, action: addNewItem)
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Lists")
        .navigationBarTitleDisplayMode(.large)
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    private func addNewItem() {
        guard let lastId = lists.isEmpty ? 0 : lists.map({ $0.id }).max() else { return }
        guard newItemName != "" else { return }

        isAddingNewItem = false

        let list = ListModel(context: viewContext)
        list.id = Int64(lastId + 1)
        list.name = newItemName

        saveContext(viewContext)
        newItemName = ""
    }
}
