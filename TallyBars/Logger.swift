//
//  Logger.swift
//  TallyBars
//
//  Created by Daniel Marriner on 13/03/2024.
//

import ATCommon

enum Logger {
    static let shared: ATCommon.Logger = LoggerBuilder
        .createLogger("TallyBars", from: ConsoleLogger())
        .build()
}
