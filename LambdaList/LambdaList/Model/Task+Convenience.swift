//
//  Task+Convenience.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    convenience init(taskName: String,
                     taskID: UUID = UUID(),
                     taskDescription: String,
                     sort: Int64 = 1,
                     createdDate: Date = Date(),
                     completed: Bool = false,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.taskName = taskName
        self.taskID = taskID
        self.taskDescription = taskDescription
        self.sort = sort
        self.createdDate = createdDate
        self.completed = completed
    }
}
