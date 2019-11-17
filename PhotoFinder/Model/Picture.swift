//
//  Picture.swift
//  PhotoFinder
//
//  Created by Rupali on 14.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

struct Picture {
    let image: UIImage
    let width: Int?
    let height: Int?

    init(image: UIImage, width: Int = 0, height: Int = 0) {
        self.image = image
        self.width = width
        self.height = height
    }
}

