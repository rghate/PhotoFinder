//
//  PictureCell.swift
//  PhotoFinder
//
//  Created by Rupali on 14.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    //MARK: Public properties
    var picture: Picture? {
        didSet {
            if let urlString = picture?.previewURL {
                pictureView.loadImage(withUrlString: urlString)
            }
        }
    }
    
    //MARK: Private properties
    
    fileprivate let pictureView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        //default color before image loading
        imageView.backgroundColor = .placeholderBackgroundColor
        return imageView
    }()
    
    //MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .placeholderBackgroundColor
        
        addSubview(pictureView)
        //make pictureview size same as the cell size
        pictureView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
