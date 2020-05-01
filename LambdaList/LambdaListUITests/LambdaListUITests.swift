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
        let app = XCUIApplication()

        XCTAssert(!app.buttons["Logout"].exists, "⚠️ Not on Login Screen")

        app.segmentedControls.buttons["Log In"].tap()

        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("gerrior04")

        let passwordSecureTextField = app.secureTextFields["Password"]

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")

        app.buttons["Log In"].tap()

        XCTAssert(app.navigationBars["Lambda List"].staticTexts["Lambda List"].exists, "⚠️ Was not able to login")
    }

    // Make sure you are logged out of the app before beginning
    // Make sure "Connected Hardware Keyboard" is unchecked.
    func testSignUp() throws {
        let app = XCUIApplication()

        // We should not be on the Logout screen
        XCTAssert(!app.buttons["Logout"].exists, "⚠️ Not on Login Screen")

        app.segmentedControls.buttons["Sign Up"].tap()

        app.textFields["ls.email"].tap()
        app.textFields["ls.email"].typeText("gerrior04@m.gerrior.com")

        app.textFields["ls.username"].tap()
        app.textFields["ls.username"].tap()
        app.textFields["ls.username"].typeText("gerrior04")

        let passwordSecureTextField = app.secureTextFields["ls.password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")

        app.buttons["ls.ActionButton"].tap()

        // We should land on Login Screen
        XCTAssert(!app.textFields["ls.email"].exists, "⚠️ Was not bounce to login screen")
    }

    func testLogout() throws {
        let app = XCUIApplication()
        sleep(1)
        XCTAssert(!app.buttons["Log In"].exists, "⚠️ Not on Logout Screen")
        app.buttons["Logout"].tap()
        XCTAssert(app.buttons["Log In"].exists, "⚠️ Not on Log In Screen")
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
