//
//  TaskViewModel.swift
//  Task manager
//
//  Created by Mahfuz on 20/1/25.
//

import SwiftUI

struct TaskViewModel: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var title: String = ""
    var description: String = ""
    var dateAndTime: Date = Date()
    var isNotificationEnabled: Bool = false
    var isFavourite: Bool = false
    init(title: String, description: String, dateAndTime: Date, isNotificationEnabled: Bool = false, isFavorite: Bool = false) {
        self.title = title
        self.description = description
        self.dateAndTime = dateAndTime
        self.isNotificationEnabled = isNotificationEnabled
        self.isFavourite = isFavorite
    }
    
    
}
