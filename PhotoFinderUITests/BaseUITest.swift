//
//  BaseUITest.swift
//  PhotoFinderUITests
//
//  Created by Rupali on 20.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import XCTest

class BaseUITest: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")

        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: timeout) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }


}
