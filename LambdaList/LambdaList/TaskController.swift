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

struct User: Codable {
    var username: String
    var password: String
    var email: String?
}

class TaskController {
        
    // MARK: - Properties

    typealias CompletionHandler = (URLResponse?, Error?) -> Void

    let baseURL = URL(string: "https://lambdawunderlist.herokuapp.com/")!
    var tasks: [Task] = []
    static var bearer: Bearer? {
        didSet {
            if let bearer = bearer {
                UserDefaults.standard.setValue(bearer.token, forKey: "token")
                UserDefaults.standard.setValue(bearer.userId, forKey: "userId")
            } else {
                print("bearer was set to nil")
            }
        }
    }
    
    static var getBearer: Bearer? {
        get {
            let token = UserDefaults.standard.value(forKey: "token") as? String
            let userId = UserDefaults.standard.value(forKey: "userId") as? Int
            guard let tempToken = token, let tempUserId = userId else {
                return nil
            }
            
            return Bearer(token: tempToken, userId: tempUserId)
        }
    }

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
    func postRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        //Setting HTTPMethod to POST
        request.httpMethod = HTTPMethod.post.rawValue

        //Header Method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    func userRegister(user: User, completion: @escaping CompletionHandler = { _, _ in }) {
        //Unwrap URL
        let signupURL = baseURL.appendingPathComponent("api/auth/register/")

        //Setting up Post Request URL
        var request = postRequest(url: signupURL)

        do {
            //Encoding User Object and getting ready to send it
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData

            //Sending Data To Server
            URLSession.shared.dataTask(with: request) { data, response, error in

                //Error Checking
                if let error = error {
                    print("Error sending data when Signing Up: \(error)")
                    completion(nil, error)
                }

                //Check response status code
                guard let response = response as? HTTPURLResponse else {
                    print("Bad Response when Signing Up")
                    completion(nil, nil)
                    return
                }

                print(response.statusCode)

                //Check data
                guard let data = data else {
                    print("Data was not received")
                    completion(nil, nil)
                    return
                }

                print("Data: \(data)")
                //                //Decode Data
                //                do {
                //                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                //                    print(self.bearer?.token)
                //                } catch {
                //                    print("Error decoding data from signup: \(error)")
                //                }
                completion(nil, nil)

            }.resume()

        } catch {
            print("Error Encoding User Object: \(error)")
        }
    }
    
    func userSignin(user: User, completion: @escaping CompletionHandler = { _, _ in }) {
        
        //Unwrap URL
        let signinURL = baseURL.appendingPathComponent("api/auth/login/")
        var request = postRequest(url: signinURL)
        
        do {
            
            //Encoding Data
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
            
            //Sending Data to Server
            URLSession.shared.dataTask(with: request) { data, response, error in
               
                //Error Checking
                if let error = error {
                    print("Error sending data when Signing Up: \(error)")
                    completion(nil, error)
                }

                //Check response status code
                guard let response = response as? HTTPURLResponse else {
                    print("Bad Response when Signing Up")
                    completion(nil, nil)
                    return
                }

                print(response.statusCode)

                //Check data
                guard let data = data else {
                    print("Data was not received")
                    completion(nil, nil)
                    return
                }
                
                //Try Unwrapping Data
                do {
                    TaskController.self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                
                    completion(nil, nil)
                } catch {
                    print("Error unwrapping data received in signin: \(error)")
                }
            }.resume()
            
        } catch {
            print("Error Encoding User in Signin: \(error)")
        }
        
        
    }

    // Create
    func createTask(_ task: Task) {
        //Save Locally
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving task in createTask: \(error)")
        }

        if let bearer = TaskController.self.getBearer {
            post(task: task, userId: "\(bearer.userId)", authToken: bearer.token)
        }
    }

    func post(task: Task,
              userId: String,
              authToken: String,
              completion: @escaping CompletionHandler = { _, _ in }) {
        if task.taskID > 0 {
            print("task.taskID == \(task.taskID). POST failed. Should this be an update?")
        }

        var requestURL = baseURL.appendingPathComponent("api/lists")
        requestURL = requestURL.appendingPathComponent(userId)

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue

        // Tell the server what it's looking at. Won't work without it since it won't "guess"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")

        do {
            guard let representation = task.createUpdateTaskRepresentation else {
                completion(nil, NSError())
                return
            }

            let encoder = JSONEncoder()
            // This will convert Date (really an Int) into a date string at encode time.
            encoder.dateEncodingStrategy = .iso8601

            request.httpBody = try encoder.encode(representation)

        } catch {
            NSLog("Error encoding/saving task: \(error)")
            completion(nil, error)
        }

        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                NSLog("Error POSTing task to server \(error)")
                completion(nil, error)
                return
            }

            if let urlResponse = urlResponse as? HTTPURLResponse,
                urlResponse.statusCode != 201 {
                NSLog("urlResponse POSTing task to server \(urlResponse)")
                completion(urlResponse, nil)
                return
            }

            if let data = data {
                //Decoding Task Object and Assigning it a ID
                do {
                    let tempTask = try JSONDecoder().decode([String: [PostTaskRepresentation]].self, from: data)
                    let otherTask = Array(tempTask.values.map { $0 })
                    
                    print(otherTask[0][0].id)
                    
                    task.taskID = Int64(otherTask[0][0].id)
                    
                    do {
                        try CoreDataStack.shared.mainContext.save()
                        print("Saving Successful")
                    } catch {
                        print("Error saving changes in post: \(error)")
                    }
                    
                    print("New Task ID: \(task.taskID)")
                    
                } catch {
                    print("Error decoding in Post to PostTaskRepresentation Object: \(error)")
                }
            }
            completion(nil, nil)
        }.resume()
        
        print("put initiated.")
    }
    
    
    // Read
    func loadTasks() {
        if let bearer = TaskController.self.getBearer {
            get(userId: "\(bearer.userId)", authToken: bearer.token)
        }
    }
    
    func get(userId: String, authToken: String, completion: @escaping CompletionHandler = { _, _ in }) {

        var requestURL = baseURL.appendingPathComponent("api/lists")
        requestURL = requestURL.appendingPathComponent(userId)

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        // Tell the server what it's looking at. Won't work without it since it won't "guess"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            // Did the call complete without error?
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(nil, error)
                return
            }

            // Did we get anything?
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(nil, NSError()) // Convert to ResultType
                return
            }

            let dateFormatter: DateFormatter = {
                // TODO: How do I use these instead?
                // let isoDateFormatter = ISO8601DateFormatter()
                // isoDateFormatter.formatOptions.insert(.withFractionalSeconds)

                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(abbreviation: "GMT")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                return formatter
            }()

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            // Unwrap the data returned in the closure.
            do {
                var tasks: [TaskRepresentation] = []

                tasks = try decoder.decode([TaskRepresentation].self, from: data)

                print("Found \(tasks.count) tasks.")

                //try self.updateEntries(with: taskRepresentation)
                completion(nil, nil)

            } catch {
                NSLog("Error decoding data from backend: \(error)")
                completion(nil, error)
            }
        }.resume()
        print("GET initiated.")
    }

    // Update
    func updateTask(_ task: Task) {

        //Save Changes to CoreData
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error Saving changes to CoreData: \(error)")
        }

        if let bearer = TaskController.self.getBearer {
            put(task: task, userId: "\(bearer.userId)", authToken: bearer.token)
        }
    }

    func put(task: Task, userId: String, authToken: String, completion: @escaping CompletionHandler = { _, _ in }) {
        if task.taskID <= 0 {
            print("task.taskID == \(task.taskID). PUT failed. Should this be a create?")
        }

        let taskId = "\(task.taskID)"

        var requestURL = baseURL.appendingPathComponent("api/lists")
        requestURL = requestURL.appendingPathComponent(userId)
        requestURL = requestURL.appendingPathComponent(taskId)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue

        // Tell the server what it's looking at. Won't work without it since it won't "guess"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")

        do {
            guard let representation = task.createUpdateTaskRepresentation else {
                completion(nil, NSError())
                return
            }

            let encoder = JSONEncoder()
            // This will convert Date (really an Int) into a date string at encode time.
            encoder.dateEncodingStrategy = .iso8601

            request.httpBody = try encoder.encode(representation)

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

            if let urlResponse = urlResponse as? HTTPURLResponse,
                urlResponse.statusCode != 200 {
                NSLog("urlResponse PUTing task to server \(urlResponse)")
                completion(urlResponse, nil)
                return
            }

            completion(nil, nil)
        }.resume()
        print("put initiated.")
    }

    // Delete
    func deleteTask(_ task: Task) {
        
        //Delete from server
        if let bearer = TaskController.self.getBearer {
            delete(task: task, userId: "\(bearer.userId)", authToken: bearer.token)
        }
        
        //Delete Locally
        CoreDataStack.shared.mainContext.delete(task)

        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error Saving Delete")
        }
    }
    
    func delete(task: Task, userId: String, authToken: String, completion: @escaping CompletionHandler = { _, _ in }) {
        if task.taskID <= 0 {
            print("task.taskID == \(task.taskID). DELETE failed.")
            return
        }

        let taskId = "\(task.taskID)"

        var requestURL = baseURL.appendingPathComponent("api/lists")
        requestURL = requestURL.appendingPathComponent(userId)
        requestURL = requestURL.appendingPathComponent(taskId)

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue

        // Tell the server what it's looking at. Won't work without it since it won't "guess"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, urlResponse, error in
            if let error = error {
                NSLog("Error DELETEing task to server \(error)")
                completion(nil, error)
                return
            }

            if let urlResponse = urlResponse as? HTTPURLResponse,
                urlResponse.statusCode != 200 {
                NSLog("urlResponse DELETEing task to server \(urlResponse)")
                completion(urlResponse, nil)
                return
            }

            completion(nil, nil)
        }.resume()
        print("DELETE initiated.")
    }
}
