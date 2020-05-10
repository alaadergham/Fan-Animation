//
//  FanAnimationUITests.swift
//  FanAnimationUITests
//
//  Created by Alaa Dergham on 5/10/20.
//  Copyright © 2020 Alaa Dergham. All rights reserved.
//

import XCTest

class FanAnimationUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFanMove() {
        
        let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .button).element.tap()
        
        let fanimgButton = app.buttons["fanImg"]
        fanimgButton.tap()
        fanimgButton.tap()
        fanimgButton.tap()
        fanimgButton.tap()
        fanimgButton.tap()
        fanimgButton.tap()
        
        let element = app.otherElements.containing(.button, identifier:"fanImg").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
        element.tap()
        
        let backButton = app.buttons["Back"]
        backButton.tap()
        element.tap()
        backButton.tap()
        element.tap()
        backButton.tap()
        element.tap()
        backButton.tap()
        fanimgButton.tap()
        
        let button = app.tabBars.children(matching: .button).element(boundBy: 2)
        button.tap()
        fanimgButton.tap()
        fanimgButton.tap()
        button.tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
