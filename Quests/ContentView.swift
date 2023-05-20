//  Quests/ContentView.swift
//  Created by Travis Luckenbaugh on 5/13/23.

import SwiftUI
import EventKit

struct ContentView: View {
    @State var events: [EKCalendarItem]? = nil
    var body: some View {
        TabView {
            NavigationView {
                EventList(data: events ?? []).navigationTitle("Events")
            }
            .onAppear {
                let store = EventManager.main.store
                let predicate = store.predicateForEvents(withStart: Month.first(for: Date.now), end: Month.last(for: Date.now), calendars: nil)
                let events = store.events(matching: predicate)
                self.events = events
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Events")
            }
            NavigationView {
                RemindersMonthView()
            }.tabItem {
                Image(systemName: "list.bullet")
                Text("Reminders")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
