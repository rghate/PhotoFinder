//
//  Picture.swift
//  PhotoFinder
//
//  Created by Rupali on 14.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

struct Picture: Decodable {
    var previewWidth: Int
    var previewHeight: Int
    var previewURL: String?
    
    enum CodingKeys: String, CodingKey {
        case previewWidth
        case previewHeight
        case previewURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        previewWidth = try (container.decodeIfPresent(Int.self, forKey: .previewWidth) ?? 0)
        previewHeight = try (container.decodeIfPresent(Int.self, forKey: .previewHeight) ?? 0)
        previewURL = try container.decodeIfPresent(String.self, forKey: .previewURL)
    }
}

struct PicturesResult: Decodable {
    let total: Int?
    let totalHits: Int?
    let pictures: [Picture]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalHits
        case pictures = "hits"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        totalHits = try container.decode(Int.self, forKey: .totalHits)
        pictures = try container.decodeIfPresent([Picture].self, forKey: .pictures) ?? [Picture]()
    }
}
