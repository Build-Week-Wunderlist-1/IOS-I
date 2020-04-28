//
//  TaskRepresentation.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation

struct TaskRepresentation: Equatable, Codable {
    
    var taskName: String
    var taskID: String
    var taskDescription: String?
    var sort: Int
    var createdDate: String
    var completed: Bool?
    
}
