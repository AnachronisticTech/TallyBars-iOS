//
//  FLiteStore.swift
//  TallyBars
//
//  Created by Daniel Marriner on 07/01/2024.
//

import SwiftUI
import FLite

class FLiteStore: ObservableObject {
    public var memory = FLite(loggerLabel: "memory-FLITE")
    public var persist = FLite(
        configuration: .file("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")/default.sqlite"),
        loggerLabel: "persisted-FLITE"
    )
}
