//
//  Item.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
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
