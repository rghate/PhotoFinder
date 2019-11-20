//
//  UIImage.swift
//  PhotoFinder
//
//  Created by Rupali on 17.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    private var imageUrlString: String?
    /**
     Method to load image from cache (or download if not available in cache) using image url string.
     
     @Param - url string of the image to be downloaded.
     */
    func loadImage(withUrlString urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid image url")
            return
        }
        
        image = nil
        //save urlString for varification purpose later
        imageUrlString = urlString
        
        let imageCache = SharedCache.shared.imageCache
        // check if image is already available in the cache. if so, load cached image.
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // if image is not available in cache, download it and store it in cache
        URLSession.shared.dataTask(with: url) { [weak self] (data, resp, err) in
            if let err = err {
                print(err)
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    guard let imageToCache = UIImage(data: data) else { return }
                    
                    // extra verification to make sure that the current imageUrlString is same as the one stored before network request
                    if self?.imageUrlString == urlString {
                        self?.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                }
            }
        }.resume()
    }
}
