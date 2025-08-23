//
//  WeatherType.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

enum WeatherType: String, CaseIterable {
    case blizzard = "강설"
    case downpour = "강우"
    case wind = "강풍"
    case clear = "맑음"
    case fog = "안개"
    case cloud = "흐림"
    
    func getKoreanName() -> String {
        switch self {
        case .blizzard:
            return "강설"
        case .downpour:
            return "강우"
        case .wind:
            return "강풍"
        case .clear:
            return "맑음"
        case .fog:
            return "안개"
        case .cloud:
            return "흐림"
        }
    }
    
    // ANON 모델용 변환 (CSV 데이터와 정확히 일치)
    func toModelValue() -> String {
        switch self {
        case .blizzard:
            return "강설"
        case .downpour:
            return "강우"
        case .wind:
            return "강풍"
        case .clear:
            return "맑음"
        case .fog:
            return "안개"
        case .cloud:
            return "흐림"
        }
    }
}

