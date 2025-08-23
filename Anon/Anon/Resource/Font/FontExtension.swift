//
//  FontExtension.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import Foundation
import SwiftUI

extension Font {
    enum Pretendard {
        
        case semiBold
        case regular
        case medium
        
        var value: String {
            switch self {
            case .semiBold:
                return "PretendardVariable-Semibold"
            case .medium:
                return "PretendardVariable-Medium"
            case .regular:
                return "PretendardVariable-Regular"
            }
        }
    }
    
    /// pretendard 폰트 생성 함수
    static func pretendard(type: Pretendard, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // semibold
    static var h4: Font {
        return .pretendard(type: .semiBold, size: 20)
    }
    static var h5: Font {
        return .pretendard(type: .semiBold, size: 18)
    }
    static var labelL: Font {
        return .pretendard(type: .semiBold, size: 18)
    }
    static var labelM: Font {
        return .pretendard(type: .semiBold, size: 18)
    }
    
    // medium
    static var h1: Font {
        return .pretendard(type: .medium, size: 32)
    }
    static var h2: Font {
        return .pretendard(type: .medium, size: 28)
    }
    static var h3: Font {
        return .pretendard(type: .medium, size: 24)
    }
    static var b1: Font {
        return .pretendard(type: .medium, size: 16)
    }
    static var b2: Font {
        return .pretendard(type: .medium, size: 14)
    }
    static var captionS: Font {
        return .pretendard(type: .medium, size: 12)
    }
    
    // regular
    static var cationL: Font {
        return .pretendard(type: .regular, size: 16)
    }
    static var captionM: Font {
        return .pretendard(type: .regular, size: 14)
    }
}
