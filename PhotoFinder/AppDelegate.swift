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
        return true
    }

    // clear all the cache (for storing downloaded images and URL cache for storing server response) used in application
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        SharedCache.shared.clearAllCache()
    }
}

