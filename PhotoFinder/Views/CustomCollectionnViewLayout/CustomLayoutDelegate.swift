///
//  CustomLayoutDelegate.swift
//  PhotoFinder
//
//  Created by Rupali on 14.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit


/**
 CustomLayoutDelegate.
 */
@objc public protocol CustomLayoutDelegate {
    /**
     Size for section header. Optional.
     
     @param collectionView - collectionView
     @param section - section for section header view
     
     Returns size for section header view.
     */
    @objc optional func collectionView(collectionView: UICollectionView,
                                       sizeForSectionHeaderView section: Int) -> CGSize
    /**
     Size for section footer. Optional.
     
     @param collectionView - collectionView
     @param section - section for section footer view
     
     Returns size for section footer view.
     */
    @objc optional func collectionView(collectionView: UICollectionView,
                                       sizeForSectionFooterView section: Int) -> CGSize
    
    /**
     Width for content of cell.
     
     @param collectionView - collectionView
     @param indexPath - index path for cell
     
     Returns width of contents of cell.
     */
    func collectionView(widthForItemIn collectionView: UICollectionView) -> CGFloat
    
    
    /**
     Height for content of cell.
     
     @param collectionView - collectionView
     @param indexPath - index path for cell
     
     Returns height of contents of cell.
     */
    func collectionView(collectionView: UICollectionView,
                        heightForItemAt indexPath: IndexPath) -> CGFloat
    

    /**
     Spacing between the rows of collectionView.
     
     @param collectionView - collectionView
     @param layout - layout of collectionView
     @param section - section of the row
     
     Returns spacing between the rows
     */
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    /**
     Spacing between the columns of collectionView.
     
     @param collectionView - collectionView
     @param layout - layout of collectionView
     @param section - section of the column
     
     Returns spacing between the columns
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
}
