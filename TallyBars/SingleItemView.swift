//
//  SingleItemView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 06/01/2024.
//

import SwiftUI
import CoreData

struct SingleItemView: View {
    @ObservedObject var item: ItemModel

    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text("\(item.count)")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard let context = item.managedObjectContext else { return }

            item.count += 1
            saveContext(context)
        }
        .onLongPressGesture {
            guard let context = item.managedObjectContext else { return }

            item.count -= 1
            saveContext(context)
        }
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
