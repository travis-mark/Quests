//  Quests/RemindersMonthView.swift
//  Created by Travis Luckenbaugh on 5/16/23.

import SwiftUI
import EventKit

public struct Group<K,G> : Hashable where K: Hashable, G: Equatable {
    public static func == (lhs: Group<K, G>, rhs: Group<K, G>) -> Bool {
        return lhs.key == rhs.key && lhs.group == lhs.group
    }
    
    public let key: K
    public let group: [G]
    
    public init(key: K, group: [G]) {
        self.key = key
        self.group = group
    }
    
    public var hashValue: Int {
        return key.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        key.hash(into: &hasher)
    }
}

public extension Sequence {
    func groupBy<U: Hashable>(_ block: (Iterator.Element) -> U) -> [Group<U,Iterator.Element>] {
        let keyArray = self.map(block)
        let keySet = Set<U>(keyArray)
        var groups: [Group<U,Iterator.Element>] = []
        
        for key in keySet {
            var items: [Iterator.Element] = []
            for (idx, item) in self.enumerated() {
                if key == keyArray[idx] {
                    items.append(item)
                }
            }
            groups.append(Group(key: key, group: items))
        }
        
        return groups
    }
}

struct RemindersMonthView: View {
    @State var reminderGroups: [Group<String, EKReminder>] = []
    @State var startDate: Date = Month.first(for: Date.now)
    @State var endDate: Date = Month.last(for: Date.now)
    
    // TODO: Takes about 1ms per record. Needs to be cached
    func refresh() {
        let m = Month.format(startDate)
        let t0 = Date().timeIntervalSince1970
        
        let store = EventManager.main.store
        let predicate = store.predicateForCompletedReminders(withCompletionDateStarting: startDate, ending: endDate, calendars: nil)
        store.fetchReminders(matching: predicate) { reminders in
            NSLog("\(m) :: \(reminders?.count ?? -1) :: \(Date().timeIntervalSince1970 - t0)")
            self.reminderGroups = reminders?.groupBy({ $0.title }) ?? []
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.startDate = Month.first(for: Month.add(amount: -1, to: startDate))
                    self.endDate = Month.last(for: self.startDate)
                    self.refresh()
                }) {
                    Image(systemName: "chevron.left")
                }.frame(minWidth: 44, minHeight: 44)
                Spacer()
                Text(Month.format(startDate))
                Spacer()
                Button(action: {
                    self.startDate = Month.first(for: Month.add(amount: 1, to: startDate))
                    self.endDate = Month.last(for: self.startDate)
                    self.refresh()
                }) {
                    Image(systemName: "chevron.right")
                }.frame(minWidth: 44, minHeight: 44)
            }
            List {
                ForEach(reminderGroups, id: \.self) { group in
                    NavigationLink(destination: EventList(data: group.group)) {
                        HStack {
                            Text(group.key)
                            Spacer()
                            Text(String(group.group.count))
                        }
                    }
                }
            }
        }.onAppear {
            self.refresh()
        }
    }
}
