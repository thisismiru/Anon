//
//  WorkDetailRowType.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI

enum WorkDetailRowType {
    case gray
    case purple
    
    var textColor: Color {
        switch self {
        case .purple:
            return Color.blue80
        default:
            return Color.neutral80
        }
    }
    
    var bgColor: Color {
        switch self {
        case .purple:
            return Color.blue5
        default:
            return Color.clear
        }
    }
    
    var borderColor: Color {
        switch self {
        case .gray:
            return Color.neutral30
        default:
            return Color.clear
        }
    }
}
