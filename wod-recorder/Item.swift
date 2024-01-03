//
//  Item.swift
//  wod-recorder
//
//  Created by Nicky Advokaat on 03/01/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
