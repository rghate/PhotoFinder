//
//  CacheTest.swift
//  PhotoFinderTests
//
//  Created by Rupali on 20.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import XCTest
@testable import PhotoFinder

class CacheTest: XCTestCase {

    func testImageCache() {
        let cache = SharedCache.shared
        let imageCache = cache.imageCache
        let imageKey: NSString = "test_image"
        
        let image = #imageLiteral(resourceName: "background")
        
        imageCache.setObject(image, forKey: imageKey)

        var cachedImage = imageCache.object(forKey: imageKey)
        //image should be cached
        XCTAssertNotNil(cachedImage)    //fails if nil
        
        //clear cache
        cache.clearAllCache()
        
        //retrieve image from cache
        cachedImage = imageCache.object(forKey: imageKey)
        XCTAssertNil(cachedImage)    //fails if not nil
    }
}
