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
            downloadPictures(refreshData: false)
        }
    }
    
    //Internal variables
    internal let interItemSpacing: CGFloat = 6  //spacing between columns of collectionView
    internal let lineSpacing: CGFloat = 6       //spacing between rows of collectionView
    internal let avgIPadCellWidth: CGFloat = 250
    internal let avgIPhoneCellWidth: CGFloat = 170
    internal var pictures: [Picture] = [Picture]()
    
    //private variables
    private var footerView: CustomFooter?
    private let footerId = "footerId"
    private let pictureCellId = "pictureCellId"
    private let headerViewHeight: CGFloat = 0
    private let footerHeightSmall: CGFloat = 90
    private let edgeInset: CGFloat = 10
    
    private lazy var portraitContentInsets = UIEdgeInsets(top: 0, left: edgeInset, bottom: 0, right: edgeInset)   //outer spacing of UICollectionView
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
        setupRefreshControl()
    }
    
    //MARK: navigationbar methods
    fileprivate func setupNavigationBar() {
        //        navigationController?.hidesBarsOnSwipe = true
        //remove back button option title
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    //MARK: collectionView methods
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .primaryBackgroundColor
        
        let layout = collectionView.collectionViewLayout as? CustomLayout
        layout?.delegate = self
        
        collectionView.contentInset = portraitContentInsets
        
        //register for picture cell
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: pictureCellId)
        
        //register footer cell
        collectionView?.register(CustomFooter.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                 withReuseIdentifier: footerId)
    }
    
    //MARK: Refresh control methods and handlers
    /**
     Function to setup refresh control on collectionView
     */
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    /**
     download pictures to reload collectionView will latest images
     */
    @objc private func handleRefresh() {
        prepareBeforeDataDownload()
        downloadPictures(refreshData: true)
    }
    
    fileprivate func endRefresh() {
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    fileprivate func downloadPictures(refreshData: Bool) {
        // if its a first page
        if currentPageNumber == 0 {
            prepareBeforeDataDownload()
        } else {
            //show wait indicator
            footerView?.setMessage(withText: "Please wait", visibleWaitIndicator: true)
        }
        
        currentPageNumber += 1
        let err = APIServiceManager.shared.getPictures(forSearchTerm: searchTerm!,
                                                       imageType: .photo,
                                                       order: .popular,
                                                       pageNumber: currentPageNumber,
                                                       loadFreshData: refreshData) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .failure(let err):
                print("Error: ", err)
                self.prepareAfterDataDownload(err: err)
            case .success(let pictures):
                if pictures.count > 0 {
                    //append newly downloaded pictures to the pictures array
                    pictures.forEach({ (picture) in
                        self.pictures.append(picture)
                    })
                } else {
                    // if no more pictures are available to download, mark paging as finished
                    self.isFinishedPaging = true
                }
                self.prepareAfterDataDownload(err: nil)
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            //show wait indicator
            self.footerView?.resetMessage(visibleWaitIndicator: false)
            
            if let err = err {
                CustomAlert().show(withTitle: "Error", message: err.localizedDescription, viewController: self) {
                    self.endRefresh()
                }
                self.footerView?.setMessage(withText: "Something is wrong 😢.\n Drag the page down to refresh.", visibleWaitIndicator:  false)
                
            } else {
                self.endRefresh()
                self.reloadCollectionView()
                
                if self.isFinishedPaging {
                    // reset pageNumber counter if all the pictures are downloaded
                    self.currentPageNumber = 0
                    if self.pictures.count == 0 {
                        // if no pictures downloaded while still being on first page, display 'zero results' message
                        self.footerView?.setMessage(withText: "Zero results found", visibleWaitIndicator: false)
                    }
                }
            }
        }
    }
    
    fileprivate func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        SharedCache.shared.clearAllCache()
    }
}

extension GridController: UICollectionViewDelegateFlowLayout {
    // Footer size
    func collectionView(collectionView: UICollectionView,
                        sizeForSectionFooterView section: Int) -> CGSize {
        if pictures.count > 0 {
            //if pictures available, reduce footer height
            return CGSize(width: view.frame.width, height: footerHeightSmall)
        } else {
            // if no pictures, display full screen footer to show either activity indicator and/or message for user
            return CGSize(width: view.frame.width, height: view.frame.height - topBarHeight)
        }
    }
    
    // footer view
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! CustomFooter
            
            self.footerView = footer
            
            return footer
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if pictures.count == 0 {
            return UICollectionViewCell()
        }
        
        // if displayed all images available in pictures array, download more pictures from next page
        if indexPath.item == self.pictures.count - 1 && !isFinishedPaging {
            downloadPictures(refreshData: false)
        }
        
        //return PictureCell if current selected layout is grid
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureCellId, for: indexPath) as! PictureCell
        cell.picture = pictures[indexPath.item]
        
        return cell
    }
    
}
