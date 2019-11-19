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

    private var isFinishedPaging: Bool = false  //flag to check when images from last availabe page are downloaded
    private var currentPageNumber = 0  //holds the page number (for pegination) while downloading images

    
    // MARK: Initializers
    
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
        
        //register for picture cell
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: pictureCellId)
        
        //register footer cell
        collectionView?.register(CustomFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    fileprivate func downloadPictures() {
        // if its a first page
        if currentPageNumber == 0 {
            prepareBeforeDataDownload()
        }
            //show wait indicator
            footerView?.setMessage(withText: "Please wait", visibleWaitIndicator: true)
        
        currentPageNumber += 1
        let err = APIServiceManager.shared.getPictures(forSearchTerm: searchTerm!, imageType: .photo, order: .popular, pageNumber: currentPageNumber) { [weak self] result in
            switch result {
            case .failure(let err):
                print("Error: ", err)
                self?.prepareAfterDataDownload(err: err)
            case .success(let pictures):
                if pictures.count > 0 {
                    //append newly downloaded pictures to the pictures array
                    pictures.forEach({ (picture) in
                        self?.pictures.append(picture)
                    })
                } else {
                    // if no more pictures are available to download, mark paging as finished
                    self?.isFinishedPaging = true
                }
                self?.prepareAfterDataDownload(err: nil)
            }
        }
        if let err = err {
            prepareAfterDataDownload(err: err)
        }
    }
    
    fileprivate func prepareBeforeDataDownload() {
        isFinishedPaging = false
        currentPageNumber = 0

        //show wait indicator
        footerView?.setMessage(withText: "Please wait", visibleWaitIndicator: true)
        
        pictures.removeAll()
        reloadCollectionView()
    }
    
    fileprivate func prepareAfterDataDownload(err: CustomError?) {
        //show wait indicator
        footerView?.resetMessage(visibleWaitIndicator: false)

        if let err = err {
            CustomAlert().show(withTitle: "Error", message: err.localizedDescription, viewController: self)
            self.footerView?.setMessage(withText: "Something is wrong 😢.\n Drag the page down to refresh.", visibleWaitIndicator:  false)
        } else {
            self.reloadCollectionView()

            if isFinishedPaging {
                // reset pageNumber counter if all the pictures are downloaded
                currentPageNumber = 0
                if self.pictures.count == 0 {
                    // if no pictures downloaded while still being on first page, display 'zero results' message
                    self.footerView?.setMessage(withText: "Zero results found", visibleWaitIndicator: false)
                }
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
            return CGSize(width: view.frame.width, height: 90)
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
        
        // if displayed all images available in pictures array, download more pictures from next page
        if indexPath.item == self.pictures.count - 1 && !isFinishedPaging {
            downloadPictures()
        }
        
        //return PictureCell if current selected layout is grid
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureCellId, for: indexPath) as! PictureCell
        cell.picture = pictures[indexPath.item]
        
        return cell
    }
    
}
