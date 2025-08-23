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
    
    func toHourMinuteAmPm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        formatter.amSymbol = " AM"
        formatter.pmSymbol = " PM"
        return formatter.string(from: self)
    }
}
