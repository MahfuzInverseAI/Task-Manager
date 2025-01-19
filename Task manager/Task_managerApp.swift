//
//  Task_managerApp.swift
//  Task manager
//
//  Created by Mahfuz on 19/1/25.
//

import SwiftUI

@main
struct Task_managerApp: App {
    @StateObject var manager = TaskFileManager()

    var body: some Scene {

        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .onAppear{
//                    manager.clearTasksFolder()
                    TaskNotificationManager.shared.requestAuthorization()
                }
        }
    }
}
