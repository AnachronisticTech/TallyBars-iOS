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
    @ObservedObject var item: ItemModel

    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text("\(item.count)")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            item.count += 1
            try? viewContext.save()
        }
        .onLongPressGesture {
            item.count -= 1
            try? viewContext.save()
        }
    }
}
