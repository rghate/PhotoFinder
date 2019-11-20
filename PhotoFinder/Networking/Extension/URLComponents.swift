//
//  URLComponents.swift
//  PhotoFinder
//
//  Created by Rupali on 18.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import Foundation

extension URLComponents {
    init(scheme: String,
         host: String,
         path: String,
         queryItems: [URLQueryItem]) {
        
        self.init()
        
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}
