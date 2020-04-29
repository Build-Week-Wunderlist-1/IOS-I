//
//  TaskController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation
import CoreData

// TODO: add firebase/ rest api url

class TaskController {
        
    // MARK: - Properties
    var tasks: [Task] = []

    // MARK: - Functions
    func getCompletedTasks() -> [Task] {
        
        var tempTasks: [Task] = []
        
        for i in tasks where i.completed == true {
            tempTasks.append(i)
        }
        
        return tempTasks
    }
    
    func getIncompleteTasks() -> [Task] {
        
        var tempTasks: [Task] = []
        
        for i in tasks where i.completed == false {
            tempTasks.append(i)
        }
        
        return tempTasks
    }

}
