//
//  ChessMasterUITests.swift
//  ChessMasterUITests
//
//  Created by Jade Davis on 2/19/24.
//

import XCTest

final class ChessMasterUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

class LoginandProfileViewUITests: XCTestCase {

    func testLoginFailure() {
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("testuser")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("testpassword")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        // Assert that login was successful
        XCTAssertTrue(app.staticTexts["Invalid Username or Password"].exists)
    }
    
    func testLoginSuccess() {
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        // Assert navigation to NavigationPage2
        // Assert if navigation to NavigationPage2 occurs
        //let navigationPage2Exists = app.staticTexts["ChessVision"].exists
        //XCTAssertTrue(navigationPage2Exists)
        let navigationPage2Exists = app.buttons["Overall Progress"].exists
        XCTAssertTrue(navigationPage2Exists)
        
    }
    
    func testUserCreateNavigation() {
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let createAccountField = app.buttons["Don't have an account? Sign Up"]
        XCTAssertTrue(createAccountField.exists)
        createAccountField.tap()
        
        let createView = app.staticTexts["CREATE ACCOUNT"].exists
        XCTAssertTrue(createView)
        
    }
    
    func testExistingUserCreatePage() {
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let createAccountField = app.buttons["Don't have an account? Sign Up"]
        XCTAssertTrue(createAccountField.exists)
        createAccountField.tap()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        let signUp = app.buttons["SIGN UP"]
        XCTAssertTrue(signUp.exists)
        signUp.tap()

        // Assert that create user was unsuccessful
        XCTAssertTrue(app.staticTexts["Username already exists"].exists)
        
    }
    
    func testCreateUser() {
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let createAccountField = app.buttons["Don't have an account? Sign Up"]
        XCTAssertTrue(createAccountField.exists)
        createAccountField.tap()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("josh")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("scoot")
        
        let signUp = app.buttons["SIGN UP"]
        XCTAssertTrue(signUp.exists)
        signUp.tap()
        
        sleep(8)
        
        // goes back to login page
        let backToLogin = app.staticTexts["ChessMaster"]
        XCTAssertTrue(backToLogin.exists)
        
        XCTAssertTrue(createAccountField.exists)
        createAccountField.tap()
        
        
    }
    
    
    
    func testDeleteProfile() {
        
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("josh")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("scoot")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        // Assert navigation to NavigationPage2
        // Assert if navigation to NavigationPage2 occurs
        //let navigationPage2Exists = app.staticTexts["ChessVision"].exists
        //XCTAssertTrue(navigationPage2Exists)
        let navigationPage2Exists = app.buttons["Overall Progress"].exists
        XCTAssertTrue(navigationPage2Exists)
        
        let systemIconImage = app.buttons["profileButton"]
                
        // Assert that the image exists
        XCTAssertTrue(systemIconImage.exists)
        
        app.buttons["profileButton"].tap()
        
        XCTAssertTrue(app.buttons["Delete Account"].exists)
        
        app.buttons["Delete Account"].tap()
        
        // Confirm deletion
        let yesButton = app.alerts.buttons["Yes"]
        XCTAssertTrue(yesButton.exists) // Make sure the "Yes" button in the confirmation alert exists
        yesButton.tap()

        // Assert absence of saved credentials
        XCTAssertNil(UserDefaults.standard.string(forKey: "username"))
        XCTAssertNil(UserDefaults.standard.string(forKey: "password"))
        
    }
    
    func testLogout() {
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        let navigationPage2Exists = app.buttons["Overall Progress"].exists
        XCTAssertTrue(navigationPage2Exists)
        
        let systemIconImage = app.buttons["profileButton"]
                
        // Assert that the image exists
        XCTAssertTrue(systemIconImage.exists)
        
        app.buttons["profileButton"].tap()
        
        XCTAssertTrue(app.buttons["Logout"].exists)
        
        app.buttons["Logout"].tap()
        
        // Confirm logout (back on login page)
        let createAccountField = app.buttons["Don't have an account? Sign Up"]
        XCTAssertTrue(createAccountField.exists)

    }
    
    func testChangePassword() {
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        let navigationPage2Exists = app.buttons["Overall Progress"].exists
        XCTAssertTrue(navigationPage2Exists)
        
        let systemIconImage = app.buttons["profileButton"]
                
        // Assert that the image exists
        XCTAssertTrue(systemIconImage.exists)
        
        app.buttons["profileButton"].tap()
        
        XCTAssertTrue(app.buttons["Change Password"].exists)
        
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley2")
        
        app.buttons["Change Password"].tap()
        
        // Confirm deletion
        let yesButton = app.alerts.buttons["Yes"]
        XCTAssertTrue(yesButton.exists)
        sleep(1)
        yesButton.tap()
        
        XCTAssertTrue(app.buttons["Logout"].exists)
        
        app.buttons["Logout"].tap()
        
        // Confirm logout (back on login page)
        let createAccountField = app.buttons["Don't have an account? Sign Up"]
        XCTAssertTrue(createAccountField.exists)
        
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley2")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        XCTAssertTrue(navigationPage2Exists)
    
        XCTAssertTrue(systemIconImage.exists)
        
        app.buttons["profileButton"].tap()
        
        XCTAssertTrue(app.buttons["Change Password"].exists)
        
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        app.buttons["Change Password"].tap()
        
        XCTAssertTrue(yesButton.exists) // Make sure the "Yes" button in the confirmation alert exists
        sleep(1)
        yesButton.tap()
        
        
    }
    func testProgressPage(){
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        let progressButton = app.buttons["Progress"]
        XCTAssert(progressButton.exists)
        progressButton.tap()
        
        sleep(1)
        
        let playAgainstBot = app.buttons["Play Against a Bot!"]
        XCTAssert(playAgainstBot.exists)
    }
    
    func testReplayView(){
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        let replayButton = app.buttons["Replay"]
        XCTAssert(replayButton.exists)
        replayButton.tap()
        
        sleep(1)
        
        let replayText = app.staticTexts["REPLAYS"]
        XCTAssert(replayText.exists)
    }
    
    func testReplayGameView(){
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        let replayButton = app.buttons["Replay"]
        XCTAssertTrue(replayButton.exists)
        replayButton.tap()
        
        sleep(1)
        
        let pred = NSPredicate(format: "identifier == 'replayList'")// Assuming your list is represented by a SwiftUI List
        let replay = app.descendants(matching: .any).matching(pred).firstMatch
        let replayListText = replay.staticTexts
        sleep(1)
        print("This is our current test:", replayListText)
        let arrCount = replayListText.count
        print("The count is",arrCount)
        
        let titleStaticText = app.staticTexts["ansley10ABCs"]
        XCTAssertTrue(titleStaticText.exists)
        titleStaticText.tap()
        sleep(10)
        let textNotes = app.staticTexts["Notes: "]
        XCTAssertTrue(textNotes.exists)
        // Ensure the list exists
        //XCTAssertTrue(replayListText.ex)

        // Tap on the first item in the list
        //let firstListItem = replayList.cells.element(boundBy: 0)
        //XCTAssertTrue(firstListItem.exists)
        //firstListItem.tap()
//        XCTAssertTrue(replayList.exists)
//        replayList.tap()
//        
//        let textNotes = app.staticTexts["Notes:"]
//        XCTAssertTrue(textNotes.exists)
    }
    func testReplaybuttons(){
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        let replayButton = app.buttons["Replay"]
        XCTAssertTrue(replayButton.exists)
        replayButton.tap()
        
        sleep(1)
        
        let pred = NSPredicate(format: "identifier == 'replayList'")// Assuming your list is represented by a SwiftUI List
        let replay = app.descendants(matching: .any).matching(pred).firstMatch
        let replayListText = replay.staticTexts
        sleep(1)
        print("This is our current test:", replayListText)
        let arrCount = replayListText.count
        print("The count is",arrCount)
        
        let titleStaticText = app.staticTexts["ansley10ABCs"]
        XCTAssertTrue(titleStaticText.exists)
        titleStaticText.tap()
        sleep(10)
        let arrowRight = app.buttons["forward"]
        XCTAssertTrue(arrowRight.exists)
        
        arrowRight.tap()
        
        let nextMove = app.staticTexts["e2e4"]
        XCTAssertTrue(nextMove.exists)
        
        let bestMove = app.buttons["bestMove"]
        XCTAssertTrue(bestMove.exists)
        
        bestMove.tap()
        let bestMoveText = app.staticTexts["g1f3"]
        XCTAssertTrue(bestMoveText.exists)
        
        let backArrow = app.buttons["backwards"]
        XCTAssertTrue(backArrow.exists)
        
        backArrow.tap()
        
        let backStaticText = app.staticTexts["your moves will appear here"]
        
        XCTAssertTrue(backStaticText.exists)
    }
    func testOverallProgress(){
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        let overallProgressButton = app.buttons["Overall Progress"]
        XCTAssertTrue(overallProgressButton.exists)
        
        overallProgressButton.tap()
        let progressText = app.staticTexts["PROGRESS"]
        XCTAssertTrue(progressText.exists)
        
    }
    func testStartGame() {
        let app = XCUIApplication()
        app.launch()
        
        // Interact with UI elements to enter username and password
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText("ansley")
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("ansley1")
        
        // Tap on the login button
        app.buttons["LOG IN"].tap()
        
        let startGameButton = app.buttons["Start Game"]
        XCTAssertTrue(startGameButton.exists)
//        startGameButton.tap()
//        sleep(2)
//        let endGameButton  = app.buttons["End Game"]
//        XCTAssertTrue(endGameButton.exists)
    }
    
}


