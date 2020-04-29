//
//  TaskRepresentation.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation

struct TaskRepresentation: Equatable, Codable {
    
    /// match exactly or else the JSON from backend server will not decode into this struct properly (omissions OK)
    var taskName: String
    var taskID: Int
    var taskDescription: String
    var sort: Int
    var createdDate: Date
    var modifiedDate: Date
    var completed: Bool
}
