//  Quests/EventList.swift
//  Created by Travis Luckenbaugh on 5/13/23.

import SwiftUI
import EventKit

struct EventList: View {
    @State var data: [EKCalendarItem] = []
    var body: some View {
        List {
            ForEach(data, id: \.self) { item in
                Text("\(item.title)")
            }
        }.onAppear {
            let store = EventManager.main.store
            let predicate: NSPredicate? = store.predicateForReminders(in: nil)
            if let predicate = predicate {
                store.fetchReminders(matching: predicate) {
                    reminders in data = reminders ?? []
                }
            }
        }
    }
}