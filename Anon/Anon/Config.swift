//
//  Config.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI

struct Config {
    private init() {}
    
    static var weatherURL: String {
        return "https://api.weatherapi.com/v1/forecast.json"
    }
    
    static var weatherApiKey: String {
        return "11dd42cb75ff4145b7291211252308"
    }
}
