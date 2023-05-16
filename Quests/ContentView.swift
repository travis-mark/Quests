//  Quests/ContentView.swift
//  Created by Travis Luckenbaugh on 5/13/23.

import SwiftUI
import EventKit

struct ContentView: View {
    @State var events: [EKCalendarItem]? = nil
    @State var reminders: [EKCalendarItem]? = nil
    var body: some View {
        TabView {
            ZStack {
                if let events = events {
                    EventList(data: events).navigationTitle("Events")
                } else {
                    Text("LOADING")
                }
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Events")
            }
            ZStack {
                if let reminders = reminders {
                    EventList(data: reminders).navigationTitle("Reminders")
                } else {
                    Text("LOADING")
                }
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Reminders")
            }
        }.onAppear {
            let store = EventManager.main.store
            // Different APIs for events and reminders why?
            // Events
            let predicate = store.predicateForEvents(withStart: Date.now.addingTimeInterval(-86400 * 365), end: Date.now, calendars: nil)
            let events = store.events(matching: predicate)
            self.events = events
            // Reminders
            store.fetchReminders(matching: store.predicateForReminders(in: nil)) {
                reminders in self.reminders = reminders ?? []
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
