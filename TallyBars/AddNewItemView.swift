//
//  AddNewItemView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 07/01/2024.
//

import SwiftUI
import ATiOS

struct AddNewItemView: View {
    @Environment(\.themeManager) private var themeManager

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
                .foregroundStyle(themeManager.accentColor)
            }
        } else {
            Button("Add new item") {
                isAddingNewItem = true
                isNewItemTextFieldFocused = true
            }
            .foregroundStyle(themeManager.accentColor)
        }
    }
}
