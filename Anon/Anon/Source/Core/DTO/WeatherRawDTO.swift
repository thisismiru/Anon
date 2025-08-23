//
//  WeatherRawDTO.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation

struct WeatherRawDTO: Decodable {
    let forecast: Forecast
    
    struct Forecast: Decodable {
        let forecastday: [ForecastDay]
        
        struct ForecastDay: Decodable {
            let hour: [HourWeather]
            
            struct HourWeather: Decodable {
                let temp_c: Double
                let humidity: Int
                let wind_kph: Double
                let gust_kph: Double
                let condition: Condition
                let time: String?
                
                struct Condition: Decodable {
                    let code: Int
                }
            }
        }
    }
}
