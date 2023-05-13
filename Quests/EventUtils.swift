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
    
    static let main = EventManager()
}
