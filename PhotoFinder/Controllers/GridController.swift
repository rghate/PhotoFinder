//
//  GridController.swift
//  PhotoFinder
//
//  Created by Rupali on 14.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

class GridController: UICollectionViewController {
    //internal variables
    internal let interItemSpacing: CGFloat = 6  //spacing between columns of collectionView
    internal let lineSpacing: CGFloat = 6       //spacing between rows of collectionView
    internal var pictures: [Picture] = [Picture(image: #imageLiteral(resourceName: "img1"), width: 320, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img2"), width: 721, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img3"), width: 2400, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img4"), width: 320, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img5"), width: 718, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img6"), width: 320, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img7"), width: 1440, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img8"), width: 853, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img9"), width: 720, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img10"), width: 524, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img11"), width: 375, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img12"), width: 720, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img13"), width: 720, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img14"), width: 320, height: 480),
                                        Picture(image: #imageLiteral(resourceName: "img15"), width: 320, height: 480)
    ]
    
    //private variables
    private let pictureCellId = "pictureCellId"
    private let headerViewHeight: CGFloat = 0
    private let portraitContentInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)   //outer spacing of UICollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: private methods
    private func setupViews() {
        setupNavigationBar()
        setupCollectionView()
    }
    
    //MARK: navigationbar methods
    private func setupNavigationBar() {
        navigationController?.hidesBarsOnSwipe = true
        //remove back button option title
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    //MARK: collectionView methods
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        
        let layout = collectionView.collectionViewLayout as? CustomLayout
        layout?.delegate = self
        
        collectionView.contentInset = portraitContentInsets
        
        //start scrollview indicator below the headerViwe
        //        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //register for picture cell
        let pictureCellNib = UINib(nibName: String(describing: PictureCell.self), bundle: nil)
        collectionView.register(pictureCellNib, forCellWithReuseIdentifier: pictureCellId)
    }
}

extension GridController: UICollectionViewDelegateFlowLayout {
    //header view size
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderView section: Int) -> CGSize {
        if pictures.count > 0 {
            //if pictures available, display collectionview header with appropriate height
            return CGSize(width: view.frame.width, height: headerViewHeight)
        } else {
            //else hide collectionview header
            return CGSize(width: view.frame.width, height: 0)
        }
    }
    
    //footer view size
    func collectionView(collectionView: UICollectionView, sizeForSectionFooterView section: Int) -> CGSize {
        if pictures.count > 0 {
            //if pictures available, reduce footer height to zero to hide it
            return CGSize(width: view.frame.width, height: 0)
        } else {
            // if no pictures, display full screen footer to show either activity indicator or message for user
            return CGSize(width: view.frame.width, height: 300)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if pictures.count == 0 {
            return UICollectionViewCell()
        }
        
        //return PictureCell if current selected layout is grid
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureCellId, for: indexPath) as! PictureCell
        cell.picture = pictures[indexPath.item]
        
        return cell
    }
    
}
