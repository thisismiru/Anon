//
//  WeatherDTO.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation

struct WeatherDTO: Identifiable {
    let id = UUID()
    let time: String
    let weather: WeatherType
    let temperature: Double
    let humidity: Int
}
