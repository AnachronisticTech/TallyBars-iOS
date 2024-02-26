//
//  SettingsView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 24/02/2024.
//

import SwiftUI
import ATCommonUI
import ATSettings
import ATSettingsUI

struct SettingsView: View {
    @Environment(\.logger) private var logger
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var appIconManager = AppIconManager(PrimaryAppIcon(), alternatives: [])

    var body: some View {
        List {
            DebugView {
                Section(header: Text("Debug")) {
                    Button("Delete Data") {
                        logger.log(.notice, message: "Deleting all data")
//                            do {
//                                try SwanSongUtils.Storage.deletePlaylistsTrees()
//                            } catch {
//                                Logger.log(.error, message: "Unable to delete all playlists")
//                            }
                    }
                }
            }

            Section(header: Text("User Interface")) {
                ThemeConfigurationView(themeManager: themeManager)
            }

            if appIconManager.availableIcons.count > 1 {
                Section(header: Text("App Icon")) {
                    NavigationLink {
                        AppIconPickerView(viewModel: appIconManager)
                            .navigationTitle("Select Icon")
                            .background(Color(uiColor: .secondarySystemBackground))
                    } label: {
                        HStack {
                            Text("Select app icon")
                            Spacer()
                            AppIconView(appIcon: appIconManager.selectedIcon)
                        }
                    }
                }
            }

            Section(header: Text("Support the developer")) {
                NavigationLink {
                    DonationsView(
                        hasMadeFirstDonation: .constant(false),
                        "com.anachronistictech.smalltip",
                        "com.anachronistictech.mediumtip",
                        "com.anachronistictech.largetip"
                    )
                    .navigationTitle("Give a tip")
                } label: {
                    Text("Give a tip")
                }

//                CellButton("Share") {}
            }
        }
        .navigationTitle("Settings")
        .listStyle(.grouped)
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(ThemeManager())
    }
}
