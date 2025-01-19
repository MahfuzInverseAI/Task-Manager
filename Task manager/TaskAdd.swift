//
//  TaskAdd.swift
//  Task manager
//
//  Created by Mahfuz on 20/1/25.
//

import SwiftUI

struct TaskAdd: View {
    @EnvironmentObject var manager: TaskFileManager
    @State var task: TaskViewModel = TaskViewModel(title: "", description: "", dateAndTime: .now, isNotificationEnabled: false)
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title Section
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    TextField("Enter task title", text: $task.title)
                        .font(.headline)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                Divider()

                // Description Section
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    TextEditor(text: $task.description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(minHeight: 100, maxHeight: 150)
                        .shadow(radius: 5)
                }

                Divider()

                // Date and Time Section
                VStack(alignment: .leading) {
                    Text("Date & Time")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    DatePicker(
                        "Select Date & Time",
                        selection: $task.dateAndTime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.vertical, 10)
                }

                Divider()

                // Notification Toggle Section
                VStack(alignment: .leading) {
                    Toggle(isOn: $task.isNotificationEnabled) {
                        Text("Enable Notifications")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding(.vertical, 10)
                }

                Divider()

                // Favorite Toggle Section
                VStack(alignment: .leading) {
                    Toggle(isOn: $task.isFavourite) {
                        Text("Mark as Favorite")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .yellow))
                    .padding(.vertical, 10)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding([.top, .horizontal])
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("New Task")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button(action: {
                saveTask()
            }) {
                Text("Save")
                    .foregroundStyle(.blue)
            }
            .padding(.bottom, 5)
            .disabled(task.title.isEmpty)
        )
    }

    private func saveTask() {
        // Add notification if enabled
        if task.isNotificationEnabled {
            TaskNotificationManager.shared.addNotification(for: task)
        }

        // Save the task
        manager.writeTaskToFile(task: task)
        manager.update()

        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
}


#Preview {
    TaskAdd()
}
