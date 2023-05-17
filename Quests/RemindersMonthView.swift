//  Quests/RemindersMonthView.swift
//  Created by Travis Luckenbaugh on 5/16/23.

import SwiftUI
import EventKit

func beginningOfMonth(for date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: components) ?? date
}

func endOfMonth(for date: Date) -> Date {
    let calendar = Calendar.current
    guard let beginningOfMonth = calendar.dateInterval(of: .month, for: date)?.start else {
        return date
    }
    let components = DateComponents(month: 1, day: -1)
    return calendar.date(byAdding: components, to: beginningOfMonth) ?? date
}

struct RemindersMonthView: View {
    @State var reminders: [EKReminder] = []
    @State var startDate: Date = beginningOfMonth(for: Date.now)
    @State var endDate: Date = endOfMonth(for: Date.now)
    
    init() {
        self.refresh()
    }
    
    func refresh() {
        let store = EventManager.main.store
        let predicate = store.predicateForCompletedReminders(withCompletionDateStarting: startDate, ending: endDate, calendars: nil)
        store.fetchReminders(matching: predicate) {
            reminders in self.reminders = reminders ?? []
        }
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.startDate = beginningOfMonth(for: self.startDate.advanced(by: -86400))
                self.refresh()
            }) {
                Text("<")
            }
            Text("\(startDate) - \(endDate)")
            Button(action: {
                self.endDate = endOfMonth(for: self.endDate.advanced(by: 86400))
                self.refresh()
            }) {
                Text(">")
            }
        }
        List {
            ForEach(reminders, id: \.self) { item in
                NavigationLink(destination: EventDetailView(item: item)) {
                    Text("\(item.title)")
                }
            }
        }
    }
}
