//
//  AddNewItemView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 07/01/2024.
//

import SwiftUI
import ATSettingsUI

struct AddNewItemView: View {
    @EnvironmentObject private var themeManager: ThemeManager

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
                .foregroundStyle(Color(uiColor: themeManager.auto))
            }
        } else {
            Button("Add new item") {
                isAddingNewItem = true
                isNewItemTextFieldFocused = true
            }
            .foregroundStyle(Color(uiColor: themeManager.auto))
        }
    }
}
