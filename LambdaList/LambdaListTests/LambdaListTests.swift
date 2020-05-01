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

    // username = gerrior01
    // password = 123456
    // auth token is good for 8 days. Use testBackendSignin to refresh
    let fixedUserId = "41" // Username: gerrior02
    // swiftlint:disable line_length
    let fixedAuthToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQxLCJ1c2VybmFtZSI6ImdlcnJpb3IwMiIsInVzZXJlbWFpbCI6Imhlcm9rdWFwcDAyQG0uZ2Vycmlvci5jb20iLCJpYXQiOjE1ODgzNTg5NDgsImV4cCI6MTU4OTU2ODU0OH0.gy8clZ30B5LQWV1YzDdaViT03qPKRsuLhHlZGWP492U"
    // swiftlint:enable line_length

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Production Tests

    // Increase number on username and email for sucessful test.
    func testBackendRegisterSuccess() {
        let semiphore = expectation(description: "Completed testBackendRegisterSuccess")

        let tempUser = User(username: "gerrior04", password: "123456", email: "herokuapp04@m.gerrior.com")

        let tc = TaskController()
        tc.userRegister(user: tempUser) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                XCTAssert(false, "⚠️ testBackendRegisterSuccess Error: \(error)")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    XCTAssert(false, "⚠️ testBackendRegisterSuccess statusCode: \(urlResponse.statusCode)")
                } else {
                    print("testBackendRegisterSuccess successful!")
                }
            }
        }

        wait(for: [semiphore], timeout: 5) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    // Verify we get the expected result when you try and re-register
    func testBackendRegisterFailure() {
        let semiphore = expectation(description: "Completed testBackendRegisterFailure")

        // This user has already been created. Going to verify this scenario.
        let tempUser = User(username: "gerrior02", password: "123456", email: "herokuapp02@m.gerrior.com")

        let tc = TaskController()
        tc.userRegister(user: tempUser) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                XCTAssert(false, "⚠️ testBackendRegisterFailure unexpected Error: \(error)")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode == 500 {
                    print("testBackendRegisterFailure successful! Received 500 when re-registering")
                } else {
                    XCTAssert(false, "⚠️ testBackendRegisterFailure statusCode: \(urlResponse.statusCode)")
                }
            }
        }

        wait(for: [semiphore], timeout: 5) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    func testBackendSignin() throws {
        let semiphore = expectation(description: "Completed testBackendSignin")

        let tc = TaskController()

        // Note: We are intentionally not including email
        let creds = User(username: "gerrior01", password: "123456")

        tc.userSignin(user: creds) { urlResponse, error  in
            semiphore.fulfill()
            if error != nil {
                // Error is printed by get
                XCTAssert(false, "⚠️ testBackendSignin Error: ^^^")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    XCTAssert(false, "⚠️ testBackendSignin statusCode: \(urlResponse.statusCode)")
                }
            } else {
                XCTAssertNotNil(TaskController.getBearer, "⚠️ testBackendSignin bearer wasn't created")
                XCTAssertEqual(String(TaskController.getBearer!.userId), self.fixedUserId, "⚠️ testBackendSignin bearer is incorrect")
                XCTAssert(TaskController.getBearer!.token.count == 227, "⚠️ testBackendSignin token incorrect size")
                print("testBackendSignin successful!")
            }
        }

        wait(for: [semiphore], timeout: 5) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    func testBackendSigninFailure() throws {
        let semiphore = expectation(description: "Completed testBackendSigninFailure")

        let tc = TaskController()

        // Note: We are intentionally not including email
        let creds = User(username: "gerrior", password: "123456")

        tc.userSignin(user: creds) { urlResponse, error  in
            semiphore.fulfill()
            if error != nil {
                // Error is printed by get
                XCTAssert(false, "⚠️ testBackendSigninFailure Error: ^^^")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode == 401 /* Unauthrized */ {
                    XCTAssert(TaskController.getBearer!.token.isEmpty, "⚠️ testBackendSigninFailure token should be reset")
                    print("testBackendSigninFailure successful! We're not authorized as expected")
                } else {
                    XCTAssert(false, "⚠️ testBackendSigninFailure statusCode: \(urlResponse.statusCode)")
                }
            } else {
                XCTAssert(false, "⚠️ testBackendSigninFailure how did we get here?")
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
                XCTAssert(false, "⚠️ testBackendGet Error: ^^^")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    XCTAssert(false, "⚠️ testBackendGet statusCode: \(urlResponse.statusCode)")
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
    // Look for New Task ID in output for following tasks
    func testBackendPost() throws {
        let semiphore = expectation(description: "Completed testBackendPost")

        let task = Task(taskName: "Class Demo",
                        taskDescription: "Hello, Build Week!",
                        completed: false)

        let tc = TaskController()

        tc.post(task: task, userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                XCTAssert(false, "⚠️ testBackendPost Error: \(error)")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 201 {
                    XCTAssert(false, "⚠️ testBackendPost statusCode: \(urlResponse.statusCode)")
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
    // Look for New Task ID in output from testBackendPost and set taskID to it.
    func testBackendPut() throws {
        let semiphore = expectation(description: "Completed testBackendPut")

        let task = Task(taskName: "blank",
                        taskDescription: "blank",
                        completed: true)
        task.taskID = 142
        print(task.taskID)
        let tc = TaskController()

        tc.put(task: task, userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                XCTAssert(false, "⚠️ testBackendPut Error: \(error)")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    XCTAssert(false, "⚠️ testBackendPut statusCode: \(urlResponse.statusCode)")
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

    func testBackendPutFailure() throws {
        let semiphore = expectation(description: "Completed testBackendPutFailure")

        let task = Task(taskName: "",
                        taskDescription: "")
        task.taskID = 1
        print(task.taskID)
        let tc = TaskController()

        tc.put(task: task, userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                print("testBackendPutFailure successful! put throws an error when bogus object \(error)")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    XCTAssert(false, "⚠️ testBackendPutFailure statusCode: \(urlResponse.statusCode)")
                }
            } else {
                XCTAssert(false, "⚠️ testBackendPutFailure unreachable code")
            }
        }

        wait(for: [semiphore], timeout: 5) // blocking sync wait

        // Assertion only happens after the time out, or web request completes
        // isInverted: Indicates that the expectation is not intended to happen
        // By adding bang (!) before it, we're testing that it indeed happened!
        XCTAssertTrue(!semiphore.isInverted, "⚠️ Registering with backend failed.")
    }

    // Look for New Task ID in output from testBackendPost and set taskID to it.
    func testBackendDelete() throws {
        let semiphore = expectation(description: "Completed testBackendDelete")

        let task = Task(taskName: "",
                        taskDescription: "")
        task.taskID = 141
        print(task.taskID)
        let tc = TaskController()

        tc.delete(task: task, userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                XCTAssert(false, "⚠️ testBackendDelete Error: \(error)")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    XCTAssert(false, "⚠️ testBackendDelete statusCode: \(urlResponse.statusCode)")
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

    func testBackendDeleteFailure() throws {
        let semiphore = expectation(description: "Completed testBackendDeleteFailure")

        let task = Task(taskName: "",
                        taskDescription: "")
        task.taskID = 1 // Invalid task ID set on purpose
        print(task.taskID)
        let tc = TaskController()

        tc.delete(task: task, userId: fixedUserId, authToken: fixedAuthToken) { urlResponse, error  in
            semiphore.fulfill()
            if let error = error {
                XCTAssert(false, "⚠️ testBackendDeleteFailure Error: \(error)")
            } else if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    XCTAssert(false, "⚠️ testBackendDeleteFailure statusCode: \(urlResponse.statusCode)")
                }
            } else {
                // I consider it a bug the backend returns 200 if you delete any non-zero task.
                // Should they fix this behavior, we'll notice it and update code as necessary.
                print("testBackendDeleteFailure successful!")
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
