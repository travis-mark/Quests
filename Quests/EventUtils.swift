//  Quests/EventUtils.swift
//  Created by Travis Luckenbaugh on 5/13/23.

import Foundation
import EventKit

enum Access {
    case unknown
    case granted
    case denied(error: Error)
}

class EventManager {
    public let store: EKEventStore
    public var eventAccess: Access
    public var reminderAccess: Access
    
    init(store: EKEventStore = EKEventStore()) {
        self.store = store
        self.eventAccess = .unknown
        self.reminderAccess = .unknown
        
        self.store.requestAccess(to: .event) { granted, error in
            self.eventAccess = granted ? .granted : .denied(error: error!)
        }
        self.store.requestAccess(to: .reminder) { granted, error in
            self.reminderAccess = granted ? .granted : .denied(error: error!)
        }
    }
    
    public func fetch(withStart startDate: Date, end endDate: Date) async -> [EKCalendarItem] {
        let events: [EKEvent] = await withUnsafeContinuation { continuation in
            let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let events = store.events(matching: predicate)
            continuation.resume(returning: events)
        }
        let reminders: [EKReminder] = await withUnsafeContinuation { continuation in
            let predicate = store.predicateForCompletedReminders(withCompletionDateStarting: startDate, ending: endDate, calendars: nil)
            store.fetchReminders(matching: predicate) { reminders in
                continuation.resume(returning: reminders ?? [])
            }
        }
        return events + reminders
    }
    
    static let main = EventManager()
}
