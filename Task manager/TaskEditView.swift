//
//  TaskEditView.swift
//  Task manager
//
//  Created by Mahfuz on 20/1/25.
//

import SwiftUI

struct TaskEditView: View {
    @State var task: TaskViewModel
    @EnvironmentObject var manager: TaskFileManager
    @Environment(\.presentationMode) var presentationMode
    var fileName: String

    init(fileName: String) {
        self.fileName = fileName
        _task = State(initialValue: TaskViewModel(title: "", description: "", dateAndTime: .now))
    }

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
        .navigationTitle("Update Task")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button {
            saveTask()
        } label: {
            Text("Save")
                .foregroundStyle(.blue)
        }
        .disabled(task.title.isEmpty))
        .onAppear {
            if let loadedTask = manager.readTaskFromFile(id: fileName) {
                self.task = loadedTask
            }
        }
    }

    private func saveTask() {
        TaskNotificationManager.shared.removeNotification(for: task.id)
        if task.isNotificationEnabled {
            TaskNotificationManager.shared.addNotification(for: task)
        }

        manager.deleteTaskFile(id: task.id)
        manager.writeTaskToFile(task: task)
        manager.update()
        presentationMode.wrappedValue.dismiss()
    }
}


#Preview {
    
    TaskEditView(fileName: "")
}
