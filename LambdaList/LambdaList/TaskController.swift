//
//  TaskController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case post   = "POST"   // Create
    case get    = "GET"    // Read
    case put    = "PUT"    // Update/Replace
    case delete = "DELETE" // Delete
}

class TaskController {
        
    // MARK: - Properties
    // MARK: - Properities
    typealias CompletionHandler = (URLResponse?, Error?) -> Void
    let baseURL = URL(string: "https://lambdawunderlist.herokuapp.com/")!

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

    // MARK: - CRUD

    // Create
    // Read
    // Update
    func put(task: Task, completion: @escaping CompletionHandler = { _, _ in }) {
        let userId = "4"
        let taskId = "4" // task.taskID

        var requestURL = baseURL.appendingPathComponent("api/lists")
        requestURL = requestURL.appendingPathComponent(userId)
        requestURL = requestURL.appendingPathComponent(taskId)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue

        // Tell the server what it's looking at. Won't work without it since it won't "guess"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // swiftlint:disable line_length
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInVzZXJuYW1lIjoiZ2VycmlvcjAxIiwidXNlcmVtYWlsIjoiaGVyb2t1YXBwMDFAbS5nZXJyaW9yLmNvbSIsImlhdCI6MTU4ODE3NTM1OSwiZXhwIjoxNTg5Mzg0OTU5fQ.w4pVW9fQT1NmU3rletahQyGvocO_QxvAoBq5qGvD6VY", forHTTPHeaderField: "Authorization")
        // swiftlint:enable line_length

        do {
            guard let representation = task.taskRepresentation else {
                completion(nil, NSError())
                return
            }

            request.httpBody = try JSONEncoder().encode(representation)

        } catch {
            NSLog("Error encoding/saving task: \(error)")
            completion(nil, error)
        }

        URLSession.shared.dataTask(with: request) { _, urlResponse, error in
            if let error = error {
                NSLog("Error PUTing task to server \(error)")
                completion(nil, error)
                return
            }

            if let urlResponse = urlResponse {
                NSLog("urlResponse PUTing task to server \(urlResponse)")
                completion(urlResponse, nil)
                return
            }

            completion(nil, nil)
        }.resume()
        print("put initiated.")
    }

    // Delete

}
