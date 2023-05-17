//  Quests/MonthUtils.swift
//  Created by Travis Luckenbaugh on 5/17/23.

import Foundation

enum Month {
    static func first(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
    
    static func last(for date: Date) -> Date {
        let calendar = Calendar.current
        guard let beginningOfMonth = calendar.dateInterval(of: .month, for: date)?.start else {
            return date
        }
        let components = DateComponents(month: 1, day: -1)
        return calendar.date(byAdding: components, to: beginningOfMonth) ?? date
    }
    
    static func add(amount: Int, to date: Date) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(month: amount)
        return calendar.date(byAdding: components, to: date) ?? date
    }
    
    static func format(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM YYYY"
        return df.string(from: date)
    }
}
