//
//  GridController.swift
//  PhotoFinder
//
//  Created by Rupali on 14.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

class GridController: UICollectionViewController {
    //public variable
    var searchTerm: String? {   //TODO: ui test for empty string from searchController
        didSet {
            prepareBeforeDataDownload()
            downloadPictures()
        }
    }
    
    //internal variables
    internal let interItemSpacing: CGFloat = 6  //spacing between columns of collectionView
    internal let lineSpacing: CGFloat = 6       //spacing between rows of collectionView
    internal var footerView: CustomFooter?
    internal let footerId = "footerId"
    internal var pictures: [Picture] = [Picture]()
    
    //private variables
    private let pictureCellId = "pictureCellId"
    private let headerViewHeight: CGFloat = 0
    private let portraitContentInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)   //outer spacing of UICollectionView
    
    private lazy var topBarHeight = (self.navigationController?.navigationBar.frame.size.height ?? 0) +
        UIApplication.shared.statusBarFrame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: private methods
    fileprivate func setupViews() {
        setupNavigationBar()
        setupCollectionView()
    }
    
    //MARK: navigationbar methods
    fileprivate func setupNavigationBar() {
        navigationController?.hidesBarsOnSwipe = true
        //remove back button option title
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    //MARK: collectionView methods
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        
        let layout = collectionView.collectionViewLayout as? CustomLayout
        layout?.delegate = self
        
        collectionView.contentInset = portraitContentInsets
        
        //start scrollview indicator below the headerViwe
        //        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //register for picture cell
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: pictureCellId)
        
        //register footer cell
        collectionView?.register(CustomFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    fileprivate func downloadPictures() {
        let err = APIServiceManager.shared.getPictures(forSearchTerm: searchTerm!, imageType: .photo, order: .popular, pageNumber: 1) { [weak self] result in
            switch result {
            case .failure(let err):
                print("Error: ", err)
                self?.prepareAfterDataDownload(err: err)
            case .success(let pictures):
                //                print(pictures.count)
                self?.pictures = pictures
                self?.prepareAfterDataDownload(err: nil)
            }
            
        }
        if let err = err {
            CustomAlert().show(withTitle: "Error", message: err.localizedDescription, viewController: self)
        }
    }
    
    fileprivate func prepareBeforeDataDownload() {
        //show wait indicator
        footerView?.setMessage(withText: "Please wait", visibleWaitIndicator: true)
        
        pictures.removeAll()
//        reloadCollectionView()
    }
    
    fileprivate func prepareAfterDataDownload(err: CustomError?) {
        //show wait indicator
        footerView?.resetMessage(visibleWaitIndicator: false)
        self.reloadCollectionView()

        if let err = err {
            DispatchQueue.main.async {
                CustomAlert().show(withTitle: "Error", message: err.localizedDescription, viewController: self)
                self.footerView?.setMessage(withText: "Something is wrong 😢.\n\n Drag down to try again.", visibleWaitIndicator:  false)
            }
        }
        
    }
    fileprivate func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension GridController: UICollectionViewDelegateFlowLayout {
    // Footer size
    func collectionView(collectionView: UICollectionView, sizeForSectionFooterView section: Int) -> CGSize {
        if pictures.count > 0 {
            //if pictures available, reduce footer height to zero to hide it
            return CGSize(width: view.frame.width, height: 0)
        } else {
            // if no pictures, display full screen footer to show either activity indicator or message for user
            return CGSize(width: view.frame.width, height: view.frame.height - topBarHeight)
        }
    }
    
    // footer view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! CustomFooter
            
            self.footerView = footer
            
            return footer
        }
        return UICollectionReusableView()
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
