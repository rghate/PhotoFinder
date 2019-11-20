//
//  CustomFooter.swift
//  PhotoFinder
//
//  Custom footer class of collectionview. Contains activity indicator view and label to display
//  text message.
//
//  Created by Rupali on 17.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

class CustomFooter: UICollectionViewCell {
    
    //MARK: Private properties
    
    private let waitIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = false
        indicatorView.style = .whiteLarge
        indicatorView.color = .textColor
        return indicatorView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please wait"
        label.textColor = .textColor
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    //MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public methods
    /**
     Set text to message label, with activity indicator visibility flag.
     */
    func setMessage(withText text: String, visibleWaitIndicator: Bool) {
        self.messageLabel.text = text
        
        if visibleWaitIndicator {
            self.waitIndicator.startAnimating()
        } else {
            self.waitIndicator.stopAnimating()
        }
        self.waitIndicator.isHidden = !visibleWaitIndicator
    }
    
    /**
     Reset text from message label, with activity indicator visibility flag.
     */
    func resetMessage(visibleWaitIndicator: Bool) {
        self.messageLabel.text = ""
        
        if visibleWaitIndicator {
            self.waitIndicator.startAnimating()
        } else {
            self.waitIndicator.stopAnimating()
        }
        self.waitIndicator.isHidden = !visibleWaitIndicator
    }
    
    
    //MARK: Private methods
    
    private func setupViews() {
        addSubview(messageLabel)
        //messageLabel constraints
        messageLabel.centerInSuperview()
        
        addSubview(waitIndicator)
        //waitIndicator constraints - place it above messageLabel
        waitIndicator.anchor(top: nil, leading: leadingAnchor, bottom: messageLabel.topAnchor, trailing: trailingAnchor)
        waitIndicator.centerInSuperview(centerInX: true, centerInY: false)
    }
}
