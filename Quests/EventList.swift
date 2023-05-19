//  Quests/EventList.swift
//  Created by Travis Luckenbaugh on 5/13/23.

import SwiftUI
import EventKit

struct EventList: View {
    let data: [EKCalendarItem]
    var body: some View {
        List {
            ForEach(data, id: \.self) { item in
                NavigationLink(destination: EventDetailView(item: item)) {
                    Text("\(item.title)")
                }
            }
        }
    }
}
