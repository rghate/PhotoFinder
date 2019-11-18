//
//  Request.swift
//  PhotoFinder
//  https://pixabay.com/api/docs/
//
//  Created by Rupali on 18.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import Foundation

enum QueryItemKey: String, CaseIterable {
    case apiKey = "key"
    case searchTerm = "q"
    case imageType = "image_type"
    case order = "order"
    case page = "page"
}

enum Order: String {
    case popular
    case latest
}


enum ImageType: String {
    case photo
}

