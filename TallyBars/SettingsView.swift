//
//  SettingsView.swift
//  TallyBars
//
//  Created by Daniel Marriner on 24/02/2024.
//

import SwiftUI
import ATCommon
import ATiOS

struct SettingsView: View {
    @Environment(\.logger) private var logger
    @Environment(\.appIconManager) private var appIconManager

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
                ThemeConfigurationView()
            }

            if appIconManager.availableIcons.count > 1 {
                Section(header: Text("App Icon")) {
                    NavigationLink {
                        AppIconPickerView()
                            .background(Color(uiColor: .secondarySystemBackground))
                    } label: {
                        HStack {
                            Text("Select app icon")
                            Spacer()
                            CurrentAppIconView()
                        }
                    }
                }
            }

            Section(header: Text("Support the developer")) {
                NavigationLink {
                    DonationsView()
                } label: {
                    Text("Give a tip")
                }

                NavigationLink {
                    CrossPromoAppsView()
                        .background(Color(uiColor: .secondarySystemBackground))
                } label: {
                    Text("Other apps")
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
            .environment(\.appIconManager, AppIconManager(PrimaryAppIcon(), alternatives: []))
            .environment(\.store, Store(
                donationIds: [
                    "com.anachronistictech.smalltip",
                    "com.anachronistictech.mediumtip",
                    "com.anachronistictech.largetip"
                ]
            ))
    }
}
