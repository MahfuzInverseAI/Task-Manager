//
//  TaskNotificationManager.swift
//  Task manager
//
//  Created by Mahfuz on 21/1/25.
//

import SwiftUI
import UserNotifications

class TaskNotificationManager {
    static let shared = TaskNotificationManager()
    
     private init() {}
    
    func addNotification(for task: TaskViewModel) {
        guard task.isNotificationEnabled, task.dateAndTime > Date() else {
            print("Notification not added")
            return
        }
        
        let identifier = task.id
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            if requests.contains(where: { $0.identifier == identifier }) {
                print("Notification already scheduled for ID: \(identifier)")
                return
            }
            
            self.scheduleNotification(for: task)
        }
    }
    
    func removeNotification(for identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification removed for ID: \(identifier)")
    }
    
    private func scheduleNotification(for task: TaskViewModel) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.title
        content.sound = .default
        
        let triggerDate = task.dateAndTime.addingTimeInterval(-30 * 60)
        guard triggerDate > Date() else {
            print("Trigger time is in the past. Notification not scheduled.")
            return
        }
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(identifier: task.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled successfully for ID: \(task.id)")
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                print("Notification authorization failed with error: \(error)")
            } else {
                print("Notification authorization request completed.")
            }
        }
    }

    func isAuthorized() -> Bool {
        var isAuthorized = false
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                isAuthorized = true
            }
        }
        return isAuthorized
    }
}

