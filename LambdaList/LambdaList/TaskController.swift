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
    // MARK: - Properities
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

    func post(task: Task, userId: String, authToken: String, completion: @escaping CompletionHandler = { _, _ in }) {
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
            guard let representation = task.taskRepresentation else {
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
                NSLog("Error POSTing task to server \(error)")
                completion(nil, error)
                return
            }

            if let urlResponse = urlResponse {
                NSLog("urlResponse POSTing task to server \(urlResponse)")
                completion(urlResponse, nil)
                return
            }

            completion(nil, nil)
        }.resume()
        print("put initiated.")
    }

    // Read
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

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            // Unwrap the data returned in the closure.
            do {
                var tasks: [TaskRepresentation] = []
                tasks = Array(try decoder.decode([TaskRepresentation].self, from: data))
                print("tasks count = \(tasks)")
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
            guard let representation = task.taskRepresentation else {
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
    func delete(task: Task, userId: String, authToken: String, completion: @escaping CompletionHandler = { _, _ in }) {
        if task.taskID <= 0 {
            print("task.taskID == \(task.taskID). DELETE failed.")
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

            if let urlResponse = urlResponse {
                NSLog("urlResponse DELETEing task to server \(urlResponse)")
                completion(urlResponse, nil)
                return
            }

            completion(nil, nil)
        }.resume()
        print("DELETE initiated.")
    }
}
