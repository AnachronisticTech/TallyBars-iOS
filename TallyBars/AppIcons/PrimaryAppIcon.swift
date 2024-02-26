//
//  PrimaryAppIcon.swift
//  TallyBars
//
//  Created by Daniel Marriner on 26/02/2024.
//

import UIKit
import ATSettings

struct PrimaryAppIcon: DefaultAppIcon {
    let id: String = "Primary"
    var description: String = "Default"
    var preview: UIImage = UIImage(named: "AppIcon") ?? UIImage()
}
