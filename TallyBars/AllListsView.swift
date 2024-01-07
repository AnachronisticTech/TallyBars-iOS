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
    @State private var showsAlert = false

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
        }
        .listStyle(PlainListStyle())
        .alert(isPresented: $showsAlert, TextAlert(title: "Title") { title in
            guard let title = title, title != "" else { return }

            let list = ListModel(context: viewContext)
            list.name = title

            try? viewContext.save()
        })
        .navigationBarTitle("Lists")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(
            trailing: Button {
                withAnimation { self.showsAlert = true }
            } label: {
                Image(systemName: "plus")
            }
        )
    }
}
