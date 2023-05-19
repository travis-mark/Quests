//  Quests/EventDetailView.swift
//  Created by Travis Luckenbaugh on 5/14/23.

import SwiftUI
import EventKit

struct EventDetailTextRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
}

struct EventDetailView: View {
    let item: EKCalendarItem
    var body: some View {
        List {
            EventDetailTextRow(label: "Title", value: item.title)
            EventDetailTextRow(label: "Location", value: item.location ?? "")
            EventDetailTextRow(label: "URL", value: item.url?.absoluteString ?? "")
            EventDetailTextRow(label: "Create Date", value: item.creationDate?.description ?? "")
            EventDetailTextRow(label: "Modify Date", value: item.lastModifiedDate?.description ?? "")
            EventDetailTextRow(label: "Alarms", value: item.hasAlarms ? "Y" : "N")
            EventDetailTextRow(label: "Attendees", value: item.hasAttendees ? "Y" : "N")
            EventDetailTextRow(label: "Notes", value: item.hasNotes ? "Y" : "N")
            EventDetailTextRow(label: "Recurring", value: item.hasRecurrenceRules ? "Y" : "N")
            if let reminder = item as? EKReminder {
                EventDetailTextRow(label: "Start Date", value: reminder.startDateComponents?.description ?? "")
                EventDetailTextRow(label: "Due Date", value: reminder.dueDateComponents?.description ?? "")
                EventDetailTextRow(label: "Is Completed", value: reminder.isCompleted ? "Y" : "N")
                EventDetailTextRow(label: "Completion Date", value: reminder.completionDate?.description ?? "")
                EventDetailTextRow(label: "Priority", value: reminder.priority.description)
            }
        }.navigationTitle(item.title)
    }
}
