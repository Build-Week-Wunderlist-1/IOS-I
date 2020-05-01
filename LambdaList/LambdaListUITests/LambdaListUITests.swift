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

    // Make sure you are logged out of the app before beginning
    // Make sure "Connected Hardware Keyboard" is unchecked.
    func testLogIn() throws {
        let app = XCUIApplication()

        // We should not be on the logout screen
        XCTAssert(!app.buttons["Logout"].exists, "⚠️ Not on Login Screen")

        app.segmentedControls.buttons["Log In"].tap()

        app.textFields["ls.username"].tap()
        app.textFields["ls.username"].typeText("gerrior04")

        let passwordSecureTextField = app.secureTextFields["ls.password"]

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")

        app.buttons["square"].tap()
//        app.buttons["ls.RememberMe"].tap()

        app.buttons["ls.ActionButton"].tap()

        // We should land on the table view with the logout button.
        XCTAssert(app.buttons["Logout"].exists, "⚠️ Was not able to login")
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

    // Make sure you are logged in before beginning
    // Make sure "Connected Hardware Keyboard" is unchecked.
    func testLogout() throws {
        let app = XCUIApplication()

        // Login Screen appears for a moment. Wait for it to go away.
        sleep(1)

        // Confirm we are not on Log In screen
        XCTAssert(!app.buttons["ls.ActionButton"].exists, "⚠️ Not on Logout Screen")

        app.buttons["Logout"].tap()

        // Confirm we returned to Log In screen
        XCTAssert(app.buttons["ls.ActionButton"].exists, "⚠️ Not on Log In Screen")
    }

    // Make sure you are logged in before beginning
    // Make sure "Connected Hardware Keyboard" is unchecked.
    func testAddTask() throws {
        let app = XCUIApplication()

        // Login Screen appears for a moment. Wait for it to go away.
        sleep(1)

        // We should land on the table view with the logout button.
        XCTAssert(app.buttons["Logout"].exists, "⚠️ Not on main screen")

        app.navigationBars["Lambda List"].buttons["Add"].tap()

        app.textFields["at.Title"].tap()
        app.textFields["at.Title"].typeText("New Task")

        app.textViews["at.Description"].tap()
        app.textViews["at.Description"].typeText("Hello, world!")

        // Create task button
        app.buttons["at.Button"].tap()

        // We should land on the table view with the logout button.
        XCTAssert(app.buttons["Logout"].exists, "⚠️ Was not able add task")
    }

    // Make sure you are logged in and have run testAddTask before beginning
    // Make sure "Connected Hardware Keyboard" is unchecked.
    func testEditTask() throws {
        let app = XCUIApplication()

        // Login Screen appears for a moment. Wait for it to go away.
        sleep(1)

        app.tables.staticTexts["Hello, world!"].tap()

        let showDetailsNavigationBar = app.navigationBars["Show Details"]
        showDetailsNavigationBar.buttons["Edit"].tap()

        app.textFields["sd.Title"].tap()
        app.textFields["sd.Title"].typeText("Old Task")

        app.textViews["sd.Description"].tap()
        app.textViews["sd.Description"].typeText("Bye, world!")

        showDetailsNavigationBar.buttons["Done"].tap()

        showDetailsNavigationBar.buttons["Lambda List"].tap()

        // We should land on the table view with the logout button.
        XCTAssert(app.buttons["Logout"].exists, "⚠️ Was not able add task")

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
