//
//  LambdaListTests.swift
//  LambdaListTests
//
//  Created by Mark Gerrior on 4/29/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import XCTest
@testable import LambdaList

class LambdaListTests: XCTestCase {

    // swiftlint:disable line_length
    let fixedAuthToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInVzZXJuYW1lIjoiZ2VycmlvcjAxIiwidXNlcmVtYWlsIjoiaGVyb2t1YXBwMDFAbS5nZXJyaW9yLmNvbSIsImlhdCI6MTU4ODE3NTM1OSwiZXhwIjoxNTg5Mzg0OTU5fQ.w4pVW9fQT1NmU3rletahQyGvocO_QxvAoBq5qGvD6VY"
    // swiftlint:enable line_length

    let fixedUserId = "4"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBackendRegister() {
        let semiphore = expectation(description: "Completed testBackendRegister")

        let tempUser = User(username: "Cameron01", password: "Collins", email: "dummyemail01@yahoo.com")

        let tc = TaskController()
        tc.userRegister(user: tempUser) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                print("⚠️ testBackendRegister Error: \(error)")
                XCTAssert(false, "testBackendRegister error")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    print("⚠️ testBackendRegister statusCode: \(urlResponse.statusCode)")
                    XCTAssert(false, "testBackendRegister urlResponse")
                }
            } else {
                print("testBackendRegister successful!")
            }
        }

        wait(for: [semiphore], timeout: 5) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    // Get List of Tasks
    func testBackendGet() throws {
        let semiphore = expectation(description: "Completed testBackendGet")

        let tc = TaskController()

        tc.get(userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if error != nil {
                // Error is printed by get
                print("⚠️ testBackendGet Error: ^^^")
                XCTAssert(false, "testBackendPost error")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    print("⚠️ testBackendGet statusCode: \(urlResponse.statusCode)")
                    XCTAssert(false, "testBackendGet urlResponse")
                }
            } else {
                print("testBackendGet successful!")
            }
        }

        wait(for: [semiphore], timeout: 5) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    // Task Create
    func testBackendPost() throws {
        let semiphore = expectation(description: "Completed testBackendPost")

        let task = Task(taskName: "Mark's First Task v12",
                        taskDescription: "Hello, world! v12",
                        completed: true)

        let tc = TaskController()

        tc.post(task: task, userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                print("⚠️ testBackendPost Error: \(error)")
                XCTAssert(false, "testBackendPost error")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 201 {
                    print("⚠️ testBackendPost statusCode: \(urlResponse.statusCode)")
                    XCTAssert(false, "testBackendPost urlResponse")
                }
            } else {
                print("testBackendPost successful!")
            }
        }

        wait(for: [semiphore], timeout: 20) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    // Task Update
    func testBackendPut() throws {
        let semiphore = expectation(description: "Completed testBackendPut")

        let task = Task(taskName: "Mark's First Task v12.1",
                        taskDescription: "Hello, world! v12.1",
                        completed: true)
        task.taskID = 44
        print(task.taskID)
        let tc = TaskController()

        tc.put(task: task, userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                print("⚠️ testBackendPut Error: \(error)")
                XCTAssert(false, "testBackendPut error")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    print("⚠️ testBackendPut statusCode: \(urlResponse.statusCode)")
                    XCTAssert(false, "testBackendPut urlResponse")
                }
            } else {
                print("testBackendPut successful!")
            }
        }

        wait(for: [semiphore], timeout: 5) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    func testBackendDelete() throws {
        let semiphore = expectation(description: "Completed testBackendDelete")

        let task = Task(taskName: "Mark's First Task v8",
                        taskDescription: "Hello, world! v8",
                        completed: true)
        task.taskID = 44
        print(task.taskID)
        let tc = TaskController()

        tc.delete(task: task, userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                print("⚠️ testBackendDelete Error: \(error)")
                XCTAssert(false, "testBackendDelete error")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    print("⚠️ testBackendDelete statusCode: \(urlResponse.statusCode)")
                    XCTAssert(false, "testBackendDelete urlResponse")
                }
            } else {
                print("testBackendDelete successful!")
            }
        }

        wait(for: [semiphore], timeout: 5) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
