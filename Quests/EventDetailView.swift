//  Quests/EventDetailView.swift
//  Created by Travis Luckenbaugh on 5/14/23.

import SwiftUI
import EventKit

struct EventDetailView: View {
    let item: EKCalendarItem
    var body: some View {
        List {
            HStack {
                Text("Title")
                Spacer()
                Text(item.title)
            }
            HStack {
                Text("Location")
                Spacer()
                Text(item.location ?? "")
            }
            HStack {
                Text("URL")
                Spacer()
                Text(item.url?.absoluteString ?? "")
            }
            HStack {
                Text("Create Date")
                Spacer()
                Text(item.creationDate?.description ?? "")
            }
            HStack {
                Text("Modify Date")
                Spacer()
                Text(item.lastModifiedDate?.description ?? "")
            }
            HStack {
                Text("Alarms")
                Spacer()
                Text(item.hasAlarms ? "Y" : "N")
            }
            HStack {
                Text("Attendees")
                Spacer()
                Text(item.hasAttendees ? "Y" : "N")
            }
            HStack {
                Text("Notes")
                Spacer()
                Text(item.hasNotes ? "Y" : "N")
            }
            HStack {
                Text("Recurring")
                Spacer()
                Text(item.hasRecurrenceRules ? "Y" : "N")
            }
        }.navigationTitle(item.title)
    }
}
