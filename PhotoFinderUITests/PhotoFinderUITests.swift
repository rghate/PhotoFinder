//
//  PhotoFinderUITests.swift
//  PhotoFinderUITests
//
//  Created by Rupali on 13.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import XCTest

class PhotoFinderUITests: BaseUITest {
    
    func testSearchFieldTextLength() {
        let app = XCUIApplication()
        
        let searchTextField = app.textFields["search textfield"]
        searchTextField.tap()
    searchTextField.typeText("wgdqedoivtebmblyjntheaoomdgqqcvsbgmgyypxigjzkreynljiovdyengkviuvqfiwzmtqemhaqiganxirojwbocvaxsolttilibbnoeqcogiqgthzkxsqptcjhtmutwfztlgagldzrbufkqnnlunmwaxeocgfwgdqedoivteb")
        
        app.buttons["search button"].tap()
        waitForElementToAppear(element: app.alerts.firstMatch)
        XCTAssertTrue(app.alerts.firstMatch.staticTexts.firstMatch.label.contains("Limit Exceeded"), "Expected \"Limit Exceeded\" text in the app alert when search string contains more than 100 characters")
        app.alerts.firstMatch.buttons.firstMatch.tap()
    }
    
    func testEmptyTextFieldResponse() {
        let app = XCUIApplication()
        
        app.buttons["search button"].tap()
        waitForElementToAppear(element: app.alerts.firstMatch)
        XCTAssert(app.alerts.firstMatch.staticTexts.firstMatch.label.contains("Please enter search term"), "Expected an error message when search button is pressed without entering search text.")
        
        app.alerts.firstMatch.buttons.firstMatch.tap()
    }
    
    func testGridViewControllerLaunch() {
        let app = XCUIApplication()
        
        let searchTextField = app.textFields["search textfield"]
        searchTextField.tap()
        
        searchTextField.typeText("London")
        app.buttons["search button"].tap()
        waitForElementToAppear(element: app.collectionViews.firstMatch)
        app.buttons["Back"].tap()
//        app.navigationBars.buttons.firstMatch.tap()
    }
}
