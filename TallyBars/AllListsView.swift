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
    @State private var isShowingEditAlert = false
    @State private var isAddingNewItem = false
    @State private var newItemName = ""

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ListModel.id, ascending: true)]) private var lists: FetchedResults<ListModel>

    var body: some View {
        List {
            ForEach(lists, id: \.id) { list in
                NavigationLink {
                    SingleListView(list: list)
                        .environment(\.managedObjectContext, viewContext)
                } label: {
                    Text(list.name)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button("Edit", systemImage: "pencil.circle") {
                        isShowingEditAlert = true
                    }
                }
                .alert("Edit list name", isPresented: $isShowingEditAlert) {
                    TextField("List Name", text: $newItemName)
                    Button("Save") {
                        let name = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !name.isEmpty else { return }
                        list.name = name
                        saveContext(viewContext)
                        newItemName = ""
                    }

                    Button("Cancel", role: .cancel) {
                        isShowingEditAlert = false
                    }
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
        .toolbar {
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gear")
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

#Preview {
    let list = ListModel(context: PersistenceController.preview.container.viewContext)
    list.name = "List with some really long name no one can be bothered to remember"

    return NavigationView {
        AllListsView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
