//
//  TaskDisplay.swift
//  Task manager
//
//  Created by Mahfuz on 20/1/25.
//

import SwiftUI

struct TaskDisplay: View {
    @EnvironmentObject var manager: TaskFileManager
    var task: TaskViewModel

    init(task: TaskViewModel) {
        self.task = task
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title and Favorite Indicator
                HStack {
                    Text(task.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)

                    Spacer()

                    // Favorite Indicator
                    Image(systemName: task.isFavourite ? "star.fill" : "star")
                        .foregroundColor(task.isFavourite ? .yellow : .gray)
                        .font(.title)
                        .padding(.top, 10)
                }

                Divider()

                // Description Section
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(task.description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .padding(.top, 5)
                }

                Divider()

                // Date and Time Section
                VStack(alignment: .leading) {
                    Text("Date & Time")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    HStack {
                        Text(task.dateAndTime, style: .date)
                            .font(.body)
                            .foregroundColor(.gray)

                        Spacer()

                        Text(task.dateAndTime, style: .time)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 5)
                }

                Divider()

                // Notification Indicator
                HStack {
                    Text("Notification")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Image(systemName: "bell" + (task.isNotificationEnabled ? ".fill" : ""))
                        .foregroundColor(task.isNotificationEnabled ? .blue : .gray)
                        .font(.title2)
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding([.top, .horizontal])
        }
        .background(Color(.systemGroupedBackground))
    }
}


#Preview {
    let task = TaskViewModel(title: "aa", description: "bb", dateAndTime: Date(), isNotificationEnabled: true)
    TaskDisplay(task: task)
}
