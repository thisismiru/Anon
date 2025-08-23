//
//  WeatherType.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

enum WeatherType: String, CaseIterable {
    case blizzard = "Blizzard"
    case downpour = "Downpour"
    case clear = "Clear"
    case wind = "Wind"
    case fog = "Fog"
    case cloud = "Cloud"
    
    func getKoreanName() -> String {
        switch self {
        case .blizzard:
            return "강설"
        case .downpour:
            return "강우"
        case .clear:
            return "맑음"
        case .wind:
            return "강풍"
        case .fog:
            return "안개"
        case .cloud:
            return "흐림"
        }
    }
    
    // ANON 모델용 변환
    func toModelValue() -> String {
        switch self {
        case .blizzard:
            return "snowy"
        case .downpour:
            return "rainy"
        case .clear:
            return "sunny"
        case .wind:
            return "windy"
        case .fog:
            return "foggy"
        case .cloud:
            return "cloudy"
        }
    }
}

