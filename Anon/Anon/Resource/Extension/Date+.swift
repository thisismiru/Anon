//
//  Date+.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation

extension Date {
    func toHourMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
