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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBackendPut() throws {

        let task = Task(taskName: "Mark's First Task v4",
                        taskDescription: "Hello, world! v4")

        let tc = TaskController()

        tc.put(task: task) { urlResponse, error  in
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

        sleep(10000) // FIXME: Not the correct way to do this.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
