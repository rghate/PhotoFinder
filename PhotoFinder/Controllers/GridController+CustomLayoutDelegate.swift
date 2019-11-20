//
//  GridController+CustomLayoutDelegate.swift
//  MyImageGallery
//
//  Created by RGhate on 13.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

extension GridController: CustomLayoutDelegate {
    
    //spacing between rows
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    //spacing between columns
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(widthForItemIn collectionView: UICollectionView) -> CGFloat {
        return getItemWidth()
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForItemAt indexPath: IndexPath) -> CGFloat {
        let picture = pictures[indexPath.item]
        return calculateCellItemHeight(for: picture)
    }
    
    private func calculateCellItemHeight(for picture: Picture) -> CGFloat {
        let imageWidth = picture.previewWidth
        let imageHeight = picture.previewHeight
        
        //calculate image height and width while maintaining its aspect ratio
        let cellWidth = getItemWidth()
        let scale: CGFloat = cellWidth / CGFloat(imageWidth)
        let scaledImgHeight: CGFloat = CGFloat(imageHeight) * scale //scale up/down image height based on scale value of width to keep the aspect ratio of the image.
        
        return scaledImgHeight
    }
    
    /**
     Function to get approx width of the collectionView cell based on the device being used.
     Works properly with iPhone 6 and above
     */
    private func getItemWidth() -> CGFloat {
        switch UIDevice().model.lowercased() {
        case "ipad":
            return avgIPadCellWidth
        default:
            return avgIPhoneCellWidth
        }
    }
    
}

