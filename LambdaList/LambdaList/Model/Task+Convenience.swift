//
//  Task+Convenience.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation
import CoreData

/// Because we choose Codegen: "class definition" in Tasks.xcdaatamodeld, Task gets generated behind the scenes
extension Task {

    /// This is what gets called when you prepare to send to the backend.
    var taskRepresentation: TaskRepresentation? {
        guard let taskName = taskName else { return nil }

        // Backend uses Int for Bool. Convert to Int
        let completedAsInt = completed == true ? 1 : 0

        return TaskRepresentation(taskName: taskName,
// FIXME:                                 taskID: Int(taskID),
                                  taskDescription: taskDescription ?? "",
                                  sort: Int(sort),
                                  createdDate: createdDate ?? Date(),
                                  modifiedDate: modifiedDate ?? Date(),
                                  completed: completedAsInt
        )
    }

    /// This is the original init before we added REST API
    @discardableResult convenience init(taskName: String,
                     taskDescription: String,
                     taskID: Int = 1,
                     sort: Int = 1,
                     createdDate: Date = Date(),
                     modifiedDate: Date = Date(),
                     completed: Bool = false,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        /// Magic happens here
        self.init(context: context)

        self.taskName = taskName
        self.taskID = Int64(taskID)
        self.taskDescription = taskDescription
        self.sort = Int64(sort)
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.completed = completed
    }

    /// Convenience Initializer
    /// Items coming in from backend for CoreData
    @discardableResult convenience init?(taskRepresentation: TaskRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        // Server is going to give us an Int; convert to Bool
        let completed = taskRepresentation.completed == 0 ? false : true

        self.init(taskName: taskRepresentation.taskName,
                  taskDescription: taskRepresentation.taskDescription,
// FIXME:                  taskID: taskRepresentation.taskID,
                  sort: taskRepresentation.sort,
                  createdDate: taskRepresentation.createdDate,
                  modifiedDate: taskRepresentation.modifiedDate,
                  completed: completed,
                  context: context)
    }
}
