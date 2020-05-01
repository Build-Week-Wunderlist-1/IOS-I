//
//  LambdaListUITests.swift
//  LambdaListUITests
//
//  Created by Mark Gerrior on 4/29/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import XCTest

class LambdaListUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogIn() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()

        XCTAssert(!app.navigationBars["Lambda List"].buttons["Logout"].exists, "⚠️ Not on Login Screen")

        app.segmentedControls.buttons["Log In"].tap()
        app.textFields["Username:"].tap()
        app.textFields["Username:"].typeText("gerrior04")

        let passwordSecureTextField = app.secureTextFields["Password"]

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")

        app.buttons["Log In"].tap()

        XCTAssert(app.navigationBars["Lambda List"].staticTexts["Lambda List"].exists, "⚠️ Was not able to login")

//        app.navigationBars["Lambda List"].buttons["Logout"].tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".segmentedControls.buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.segmentedControls.buttons["Sign Up"].tap()
//        app.buttons["square"].tap()


    }

    func testLogOut() throws {
        XCTAssert(!app.navigationBars["Lambda List"].buttons["Logout"].exists, "⚠️ Not on Login Screen")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
