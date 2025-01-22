//
//  MainScreen.swift
//  Task manager
//
//  Created by Mahfuz on 20/1/25.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var manager: TaskFileManager
    @State var showAlert: Bool = false
    @State var deletedID: String? = nil
    @State private var searchText: String = ""
    @State private var showOnlyFavorites: Bool = false

    var filteredTasks: [String] {
        var tasks = manager.fileNames

        if searchText.isEmpty {
            tasks = tasks.filter { fileName in
                if let task = manager.readTaskFromFile(id: fileName) {
                    return !showOnlyFavorites || task.isFavourite
                }
                return false
            }
        } else {
            tasks = tasks.filter { fileName in
                if let task = manager.readTaskFromFile(id: fileName) {
                    return task.title.localizedCaseInsensitiveContains(
                        searchText) && (!showOnlyFavorites || task.isFavourite)
                }
                return false
            }
        }
        return tasks
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search tasks...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Toggle("Favorites", isOn: $showOnlyFavorites)
                        .padding(.horizontal)
                        .toggleStyle(.button)
                        .tint(Color.yellow)
                        .foregroundStyle(.primary)
                }

                Group {
                    if filteredTasks.isEmpty {
                        VStack {
                            Image(systemName: "tray")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding()

                            Text("No Tasks Available")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                        .padding()
                    } else {
                        List {
                            Section(header: Text("Task List")) {
                                ForEach(filteredTasks.indices, id: \.self) {
                                    index in
                                    if let task = manager.readTaskFromFile(
                                        id: filteredTasks[index])
                                    {
                                        HStack {
                                            NavigationLink {
                                                TaskDisplay(task: task)
                                            } label: {
                                                VStack(alignment: .leading) {
                                                    Text("\(task.title)")
                                                        .font(.headline)
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())

                                            Spacer()
                                            HStack(spacing: 0) {
                                                Image(
                                                    systemName: task
                                                        .isFavourite
                                                        ? "star.fill"
                                                        : "star"
                                                )
                                                .frame(maxHeight: .infinity)
                                                .foregroundColor(
                                                    task.isFavourite
                                                        ? .yellow : .gray
                                                )
                                                .padding()
                                                .onTapGesture {
                                                    manager.deleteTaskFile(
                                                        id: task.id)
                                                    var newTask = task
                                                    newTask.isFavourite.toggle()
                                                    manager.writeTaskToFile(
                                                        task: newTask)
                                                    manager.update()
                                                }

                                                Menu {
                                                    NavigationLink {
                                                        TaskEditView(
                                                            fileName:
                                                                filteredTasks[
                                                                    index])
                                                    } label: {
                                                        Text("Update")
                                                    }

                                                    Button {
                                                        showAlert.toggle()
                                                        deletedID =
                                                            filteredTasks[index]
                                                    } label: {
                                                        Text("Delete")
                                                    }
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        maxHeight: .infinity
                                                    )
                                                } label: {
                                                    Image(
                                                        systemName:
                                                            "line.3.horizontal"
                                                    )
                                                    .padding(.horizontal)
                                                    .frame(maxHeight: .infinity)
                                                    .tint(Color.primary)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text(""),
                        primaryButton: .destructive(Text("Yes")) {
                            if let deletedID {
                                manager.deleteTaskFile(id: deletedID)
                                manager.update()
                            }
                        },
                        secondaryButton: .cancel(Text("No")) {}
                    )
                }
            }
            .padding(.top)
            .navigationBarItems(
                leading: Text("Task Manager").bold().font(.title),
                trailing: NavigationLink(
                    destination: {
                        TaskAdd()
                    },
                    label: {
                        Image(systemName: "plus.circle")
                            .font(.title)
                    })
            )
        }
        .onAppear {
            manager.update()
        }
    }
}

#Preview {
    MainScreen()
}
