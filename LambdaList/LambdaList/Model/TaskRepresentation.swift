//
//  TaskRepresentation.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation



struct PostTaskRepresentation: Codable {
    let id: Int
    let taskName, taskDescription: String
    let sortField: Int
    let creationDate, modifiedDate: String
    let completed: Bool
}


struct TaskRepresentation: Equatable, Codable {

    /// This is about conforming to the data that we are reading in. So case name doesn't have to match fullname
    enum CodingKeys: String, CodingKey {
        case taskID = "todo_id"
        case taskName
        case taskDescription
        case sort = "sortField"
        case createdDate = "creationDate"
        case modifiedDate
        case completed
    }

    /// match exactly or else the JSON from backend server will not decode into this struct properly (omissions OK)
    var taskID: Int
    var taskName: String
    var taskDescription: String
    var sort: Int
    var createdDate: Date
    var modifiedDate: Date
    var completed: Bool
}

struct CreateUpdateTaskRepresentation: Equatable, Codable {

    /// This is about conforming to the data that we are reading in. So case name doesn't have to match fullname
    enum CodingKeys: String, CodingKey {
        case taskName
        case taskDescription
        case sort = "sortField"
        case createdDate = "creationDate"
        case modifiedDate
        case completed
    }

    /// match exactly or else the JSON from backend server will not decode into this struct properly (omissions OK)
    var taskName: String
    var taskDescription: String
    var sort: Int
    var createdDate: Date
    var modifiedDate: Date
    var completed: Bool
}
