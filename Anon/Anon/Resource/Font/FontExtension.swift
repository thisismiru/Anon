//
//  FontExtension.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import Foundation
import SwiftUI

extension Font {
    /// ArialBlack font factory
    static func arialBlack(size: CGFloat) -> Font {
        .custom("Arial-Black", size: size)
    }
        
    enum Pretendard {
        case semiBold
        case medium
        case regular
        
        var value: String {
            switch self {
            case .semiBold:
                return "PretendardVariable-SemiBold"
            case .medium:
                return "PretendardVariable-Medium"
            case .regular:
                return "PretendardVariable-Regular"
            }
        }
    }
    
    /// Pretendard font factory
    static func pretendard(type: Pretendard, size: CGFloat) -> Font {
        .custom(type.value, size: size)
    }
    
    // MARK: - Heading
    static var h1: Font {       // Medium, 32pt
        .pretendard(type: .medium, size: 32)
    }
    static var h2: Font {       // Medium, 28pt
        .pretendard(type: .medium, size: 28)
    }
    static var h3: Font {       // SemiBold, 24pt
        .pretendard(type: .semiBold, size: 24)
    }
    static var h4: Font {       // SemiBold, 20pt
        .pretendard(type: .semiBold, size: 20)
    }
    static var h5: Font {       // SemiBold, 18pt
        .pretendard(type: .semiBold, size: 18)
    }
    
    // MARK: - Body
    static var b1: Font {       // Medium, 16pt
        .pretendard(type: .medium, size: 16)
    }
    static var b2: Font {       // Medium, 14pt
        .pretendard(type: .medium, size: 14)
    }
    
    // MARK: - Label
    static var labelL: Font {   // SemiBold, 16pt
        .pretendard(type: .semiBold, size: 16)
    }
    static var labelM: Font {   // SemiBold, 14pt
        .pretendard(type: .semiBold, size: 14)
    }
    
    // MARK: - Caption
    static var captionL: Font { // Regular, 16pt
        .pretendard(type: .regular, size: 16)
    }
    static var captionM: Font { // Regular, 14pt
        .pretendard(type: .regular, size: 14)
    }
    static var captionS: Font { // Medium, 12pt
        .pretendard(type: .medium, size: 12)
    }
}
