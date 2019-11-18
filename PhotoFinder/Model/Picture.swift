//
//  Picture.swift
//  PhotoFinder
//
//  Created by Rupali on 14.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit


struct Snap/*: Decodable */{

    let image: UIImage
    let width: Int?
    let height: Int?

    init(image: UIImage, width: Int = 0, height: Int = 0) {
        self.image = image
        self.width = width
        self.height = height
    }
}

struct Picture: Decodable {
/*
        var id: String?
        var userId: String?
        var userImageURL: String?
        var user: String?

        var imageWidth: Int?
        var imageHeight: Int?
        var imageSize: Int?
        var largeImageURL : String?
        var webformatHeight: Int?
        var webformatWidth: Int?
        var webformatURL: String?
        var likes: Int?
        var views: Int?
        var comments: Int?
        var downloads: Int?
        var favorites: Int?
        var pageURL: String?
        var type: String?
        var tags: [String]?
*/
        var previewWidth: Int
        var previewHeight: Int
        var previewURL: String?
    
    enum CodingKeys: String, CodingKey {
//        case userId = "user_id"
        case previewWidth
        case previewHeight
        case previewURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        previewWidth = try (container.decodeIfPresent(Int.self, forKey: .previewWidth) ?? 0)
        previewHeight = try (container.decodeIfPresent(Int.self, forKey: .previewHeight) ?? 0)
        previewURL = try container.decodeIfPresent(String.self, forKey: .previewURL)
        
        print("Width: \(previewWidth)")
        print("Height: \(previewHeight)")
        print("URL: \(previewURL ?? "")")
        print("---------------------------")
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
//        print(hits.count)
    }
}
