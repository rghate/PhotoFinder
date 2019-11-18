///
//  CustomLayoutAttributes.swift
//  PhotoFinder
//
//  Created by Rupali on 14.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit


/**
 CollectionViewLayoutAttributes.
 */
public class CustomLayoutAttributes: UICollectionViewLayoutAttributes {
    /**
     Image height to be set to contstraint in collection view cell.
     */
    public var cellContentHeight: CGFloat = 0
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CustomLayoutAttributes
        copy.cellContentHeight = cellContentHeight
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? CustomLayoutAttributes {
            if attributes.cellContentHeight == cellContentHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}
