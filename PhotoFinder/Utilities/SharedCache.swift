//
//  CacheUtility.swift
//  PhotoFinder
//
//  Created by Rupali on 19.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

class SharedCache {
    static let shared = SharedCache()
    
    let imageCache: NSCache = NSCache<NSString, UIImage>()

    private init() {
        // setup URL cache in memory to cache response from server
        let cacheSizeMegabytes = 10
          URLCache.shared = URLCache(
              memoryCapacity: cacheSizeMegabytes * 1024 * 1024,
              diskCapacity: 0,
              diskPath: nil)
    }
    /**
        Function to clear image  as well as URLcache
     */
    func clearAllCache() {
        DispatchQueue.global(qos: .background).async {
            // clear image cache
            self.imageCache.removeAllObjects()
            // clear URL cache
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
    func clearURLCache(for fetchRequest: URLRequest, dataTask: URLSessionDataTask) {
         URLCache.shared.removeCachedResponse(for: fetchRequest)
         URLCache.shared.removeCachedResponse(for: dataTask)
     }
}
