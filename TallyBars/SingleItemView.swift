//
//  SingleItemView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 06/01/2024.
//

import SwiftUI
import CoreData

struct SingleItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.logger) private var logger

    @State private var isShowingEditAlert = false
    @State private var itemNewName = ""

    @ObservedObject var item: ItemModel

    var body: some View {
        HStack {
            Text(item.name)
            Spacer()

            Image(systemName: "minus.circle")
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .onTapGesture {
                    item.count -= 1
                    saveContext(viewContext)
                }

            Text("\(item.count)")
                .padding([.leading, .trailing])

            Image(systemName: "plus.circle")
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .onTapGesture {
                    item.count += 1
                    saveContext(viewContext)
                }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Edit", systemImage: "pencil.circle") {
                isShowingEditAlert = true
            }
        }
        .alert("Edit item name", isPresented: $isShowingEditAlert) {
            TextField("Item Name", text: $itemNewName)
            Button("Save") {
                let name = itemNewName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !name.isEmpty else { return }
                item.name = name
                saveContext(viewContext)
            }

            Button("Cancel", role: .cancel) {
                isShowingEditAlert = false
            }
        }
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            logger.log(.error, message: "Failed to save context: \(error)")
        }
    }
}

#Preview {
    let item = ItemModel(context: PersistenceController.preview.container.viewContext)
    item.name = "Test item with a really long title because people dislike non-descriptive variable names"

    return List {
        SingleItemView(item: item)
    }
    .listStyle(.plain)
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
