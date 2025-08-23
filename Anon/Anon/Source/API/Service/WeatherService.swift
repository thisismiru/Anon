//
//  WeatherService.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation

class WeatherService {
    func fetchWeather(latitude: Float = 36,
                      longitude: Float = 129,
                      days: Int = 1,
                      hour: [Int] = [9, 10, 11, 12, 13, 14, 15],
                      completion: @escaping ([WeatherDTO]) -> Void) {
        
        let baseURL = Config.weatherURL
        let apiKey = Config.weatherApiKey
        let hourParam = hour.map { String($0) }.joined(separator: ",")
        let urlString = "\(baseURL)?q=\(latitude),\(longitude)&key=\(apiKey)&days=\(days)&hour=\(hourParam)"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                completion([])
                return
            }
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let raw = try JSONDecoder().decode(WeatherRawDTO.self, from: data)
                let list = WeatherMapper.map(from: raw)
                DispatchQueue.main.async {
                    completion(list)
                }
            } catch {
                print("❌ Decoding error:", error)
                completion([])
            }
        }.resume()
    }
}

fileprivate struct WeatherMapper {
    static func map(from raw: WeatherRawDTO, filterHours: [Int]? = nil) -> [WeatherDTO] {
        guard let hours = raw.forecast.forecastday.first?.hour else { return [] }
        
        return hours.compactMap { hour -> WeatherDTO? in
            let hourValue: Int? = {
                if let t = hour.time {
                    let parts = t.split(separator: " ")
                    if parts.count == 2 {
                        let hh = parts[1].prefix(2)
                        return Int(hh)
                    }
                }
                return nil
            }()
            
            if let filter = filterHours, let hv = hourValue, !filter.contains(hv) {
                return nil
            }
            
            return WeatherDTO(
                time: hour.time ?? "-",
                weather: mapWeatherCodeToType(
                    code: hour.condition.code,
                    windKph: hour.wind_kph,
                    gustKph: hour.gust_kph
                ),
                temperature: hour.temp_c,
                humidity: hour.humidity
            )
        }
    }
            
    
    private static func mapWeatherCodeToType(code: Int, windKph: Double, gustKph: Double) -> WeatherType {
        switch code {
        case 1000:
            return .clear
        case 1003, 1006, 1009:
            return .cloud
        case 1030, 1135, 1147:
            return .fog
        case 1063, 1150...1201, 1240...1246, 1273, 1276:
            return .downpour
        case 1066...1237, 1255...1282:
            return .blizzard
        default:
            if windKph > 30 || gustKph > 50 {
                return .wind
            }
            return .clear
        }
    }
}
