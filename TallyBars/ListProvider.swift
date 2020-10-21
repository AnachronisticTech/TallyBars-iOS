//
//  ListProvider.swift
//  TallyBars
//
//  Created by Daniel Marriner on 05/10/2020.
//

import Foundation
import Combine
import SwiftUI
import SwiftUICharts

class ListProvider: ObservableObject {
    @Published var items = [TallyItem]()
    @Published var data = ChartData(points: [Float]())
    @Published var normalisedData = ChartData(points: [Float]())

    func updateItems(from list: TallyList, in store: FLiteStore) {
        list.$items
            .query(on: store.persist.query(model: TallyItem.self).database)
            .with(\.$list)
            .all()
            .whenSuccess { items in
                DispatchQueue.main.async {
                    self.items = items
                    let min = items.map({ $0.count }).min() ?? 0
                    self.data = ChartData(values: items.map { item in
                        (item.name, item.count)
                    })
                    self.normalisedData = ChartData(values: items.map { item in
                        (item.name, item.count - min)
                    })
                }
            }
    }

    func deleteItem(at index: Int, in store: FLiteStore) {
        store.persist
            .delete(model: items[index])
            .whenSuccess {
                DispatchQueue.main.async {
                    self.items.remove(at: index)
                    self.data = ChartData(values: self.items.map { item in
                        (item.name, item.count)
                    })
                }
            }
    }
}
