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

//    var taskRepresentation: TaskRepresentation? {
//        guard let taskName = taskName else { return nil }
//
//        return TaskRepresentation(taskName: taskName,
//                                  taskID: taskID,
//                                  taskDescription: taskDescription,
//                                  sort: sort,
//                                  createdDate: createdDate,
//                                  completed: completed)
//    }

    /// This is the original init before we added REST API
    @discardableResult convenience init(taskName: String,
                     taskDescription: String,
                     taskID: Int = 1,
                     sort: Int = 1,
                     createdDate: Date = Date(),
                     completed: Bool = false,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        /// Magic happens here
        self.init(context: context)

        self.taskName = taskName
        self.taskID = Int64(taskID)
        self.taskDescription = taskDescription
        self.sort = Int64(sort)
        self.createdDate = createdDate
        self.completed = completed
    }

    /// Convenience Initializer
    /// Items coming in from Firebase for CoreData
//    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        /// mood comes in as a string from Firebase. We need to convert to Mood enum
//        guard let mood = Mood(rawValue: entryRepresentation.mood) else {
//                return nil
//        }
//
//        self.init(identifier: entryRepresentation.identifier,
//                  title: entryRepresentation.title,
//                  bodyText: entryRepresentation.bodyText,
//                  timestamp: entryRepresentation.timestamp,
//                  mood: mood,
//                  context: context)
//    }
}
