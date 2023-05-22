//  Quests/RemindersCalendarView.swift
//  Created by Travis Luckenbaugh on 5/19/23.

import SwiftUI
import EventKit

struct RemindersCalendarView: View {
    let calendar = Calendar.current
    let dayFormatter: DateFormatter
    
    init() {
        dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
    }
    
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()
    @State private var monthReminders: [EKReminder] = []
    @State private var dayReminders: [EKCalendarItem] = []
    
    func loadMonth() {
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
        let store = EventManager.main.store
        let predicate = store.predicateForCompletedReminders(withCompletionDateStarting: startDate, ending: endDate, calendars: nil)
        store.fetchReminders(matching: predicate) { reminders in
            self.monthReminders = reminders ?? []
        }
    }
    
    func loadDay() async {
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: selectedDate))!
        let endDate = calendar.date(byAdding: DateComponents(day: 1), to: startDate)!
        dayReminders = await EventManager.main.fetch(withStart: startDate, end: endDate)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.currentMonth = Month.add(amount: -1, to: currentMonth)
                    self.loadMonth()
                }) {
                    Image(systemName: "chevron.left")
                }.frame(minWidth: 44, minHeight: 44)
                Spacer()
                Text(Month.format(currentMonth))
                Spacer()
                Button(action: {
                    self.currentMonth = Month.add(amount: 1, to: currentMonth)
                    self.loadMonth()
                }) {
                    Image(systemName: "chevron.right")
                }.frame(minWidth: 44, minHeight: 44)
            }
            HStack {
                ForEach(calendar.veryShortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            VStack {
                ForEach(monthlyDates(), id: \.self) { week in
                    HStack(spacing: 0) {
                        ForEach(week, id: \.self) { date in
                            Text(dayFormatter.string(from: date))
                                .font(.body)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(isDateDisabled(date) ? Color.gray : Color(UIColor.label))
                                .background(selectedDate == date ? Color.red : Color.clear)
                                .onTapGesture {
                                    selectedDate = date
                                    Task {
                                        await self.loadDay()
                                    }
                                }
                        }
                    }
                }
            }
            EventList(data: dayReminders)
        }.onAppear {
            Task {
                self.loadMonth()
                await self.loadDay()
            }
        }
    }
    
    func monthlyDates() -> [[Date]] {
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
        
        var dates: [[Date]] = []
        
        var currentDate = startDate
        while currentDate <= endDate {
            let weekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
            
            var week: [Date] = []
            for i in 0..<7 {
                let date = calendar.date(byAdding: DateComponents(day: i), to: weekStartDate)!
                week.append(date)
            }
            
            dates.append(week)
            currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: weekStartDate)!
        }
        
        return dates
    }
    
    func isDateDisabled(_ date: Date) -> Bool {
        let month = calendar.component(.month, from: currentMonth)
        return calendar.component(.month, from: date) != month
    }
}
