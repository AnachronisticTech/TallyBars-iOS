//
//  AddNewItemView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 07/01/2024.
//

import SwiftUI

struct AddNewItemView: View {
    @Binding var newItemName: String
    @Binding var isAddingNewItem: Bool
    var action: () -> ()

    @FocusState private var isNewItemTextFieldFocused: Bool

    var body: some View {
        if isAddingNewItem {
            HStack {
                TextField("Name", text: $newItemName)
                    .focused($isNewItemTextFieldFocused)
                Spacer()
                Button("Add") {
                    action()
                    isNewItemTextFieldFocused = isAddingNewItem
                }
                .foregroundStyle(Color.blue)
            }
        } else {
            Button("Add new item") {
                isAddingNewItem = true
                isNewItemTextFieldFocused = true
            }
            .foregroundStyle(Color.blue)
        }
    }
}
