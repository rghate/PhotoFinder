//
//  AppDelegate.swift
//  PhotoFinder
//
//  Created by Rupali on 13.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // setup URL cache in memory to cache response from server
        let cacheSizeMegabytes = 10
          URLCache.shared = URLCache(
              memoryCapacity: cacheSizeMegabytes * 1024 * 1024,
              diskCapacity: 0,
              diskPath: nil)

        return true
    }

}

