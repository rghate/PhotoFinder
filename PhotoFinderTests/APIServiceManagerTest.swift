//
//  APIServiceManagerTest.swift
//  PhotoFinderTests
//
//  Created by Rupali on 20.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import XCTest
@testable import PhotoFinder

class APIServiceManagerTest: XCTestCase {

    func testGetPicture() {
        // invalid page number
        APIServiceManager.shared.getPictures(forSearchTerm: "London", pageNumber: -1, loadFreshData: true) { result in
            switch result {
                case .failure(let err):
                        XCTAssertNotNil(err, "Invalid page")    //fails if nil
                case .success(let pictures):
                        XCTAssertNil(pictures)  //fails if not nil
            }
        }
    }
}
