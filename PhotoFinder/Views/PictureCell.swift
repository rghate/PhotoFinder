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
    var picture: Snap? {
        didSet {
            if let picture = picture {
                pictureView.image = picture.image
            }
        }
    }

    @IBOutlet fileprivate weak var pictureView: UIImageView! {
        didSet {
            pictureView.layer.cornerRadius = 8
            pictureView.layer.masksToBounds = true
            pictureView.contentMode = .scaleAspectFill
            //default color before image loading
            pictureView.backgroundColor = .placeholderBackgroundColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .placeholderBackgroundColor
    }

}
