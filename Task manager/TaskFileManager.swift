//
//  TaskFileManager.swift
//  Task manager
//
//  Created by Mahfuz on 20/1/25.
//

import SwiftUI

class TaskFileManager: ObservableObject {
    @Published  var fileNames: [String] = []
    

     func writeTaskToFile(task: TaskViewModel) {
        guard
            let documentDirectory = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask
            ).first
        else {
            print("Document directory not found")
            return
        }

        let fileURL = documentDirectory.appendingPathComponent("\(task.id).json")

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(task)
            try data.write(to: fileURL)
            print("Task written to file: \(fileURL.path)")
        } catch {
            print("Error writing task to file: \(error.localizedDescription)")
        }
    }

     func readTaskFromFile(id: String) -> TaskViewModel? {
        guard
            let documentDirectory = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask
            ).first
        else {
            print("Document directory not found")
            return nil
        }

        let fileURL = documentDirectory.appendingPathComponent("\(id).json")

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let task = try decoder.decode(TaskViewModel.self, from: data)
            return task
        } catch {
            print("Error reading task from file: \(error.localizedDescription)")
            return nil
        }
    }

     func deleteTaskFile(id: String) {
        guard
            let documentDirectory = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask
            ).first
        else {
            print("Document directory not found")
            return
        }

        let fileURL = documentDirectory.appendingPathComponent("\(id).json")

        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Task deleted: \(fileURL.path)")
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }

      func getAllTaskFileNames() -> [String] {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document directory not found")
            return []
        }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            
            let fileNames = fileURLs
                .filter { $0.pathExtension == "json" }
                .map { $0.deletingPathExtension().lastPathComponent }
            
            return fileNames
        } catch {
            print("Error fetching file names: \(error.localizedDescription)")
            return []
        }
    }

    func clearTasksFolder() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document directory not found")
            return
        }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs {
                if fileURL.pathExtension == "json" { // Optional: clear only JSON files
                    try FileManager.default.removeItem(at: fileURL)
                    print("Deleted file: \(fileURL.lastPathComponent)")
                }
            }
            
            print("Tasks folder cleared successfully!")
        } catch {
            print("Error clearing tasks folder: \(error.localizedDescription)")
        }
    }
    
    func update() {
        fileNames = getAllTaskFileNames()
    }
}


