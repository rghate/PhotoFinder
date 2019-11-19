//
//  ViewController.swift
//  PhotoFinder
//
//  Created by Rupali on 13.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    //MARK: Private variables
    private let defaultSideInset: CGFloat = 16
    private let messageLabelBottomOffset: CGFloat = 100
    private let textFieldHeight: CGFloat = 40
    private let searchButtonTopOffset: CGFloat = 30
    private let searchButtonWidth: CGFloat = 170
    private let searchButtonHeight: CGFloat = 45
    
    fileprivate let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "background")
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.55
        
        return iv
    }()
    
    fileprivate let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "What would you like to search today?"
        label.textColor = UIColor.textColor
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    // TODO: textfield search value should not exceed more than 100 characters  - UI test case
    fileprivate let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.textColor = UIColor.textColor
        textField.placeholder = "Search "
        textField.returnKeyType = .search
        
        return textField
    }()
    
    fileprivate lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search pictures", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.textColor.cgColor
        button.setTitleColor(UIColor.textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleSearch() {
        dismissKeyboard()
        
        let searchTerm = textField.text ?? ""
        if searchTerm.isEmpty {
            CustomAlert().show(withTitle: "", message: "Please Enter search term", viewController: self, completion: nil)
            return
        }
        let layout = CustomLayout()
        let gridVC = GridController(collectionViewLayout: layout)
        gridVC.searchTerm = searchTerm
        navigationController?.pushViewController(gridVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        
        setupKeyboardNotifications()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Private methods
    fileprivate func setupNavigationBar() {
        //make navigation bar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
        navigationController?.navigationBar.tintColor = UIColor.textColor
        
        navigationItem.title = "Search"
    }
    
    fileprivate func setupViews() {
        // background image
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        view.sendSubviewToBack(backgroundImageView)
        
        // search textfield
        view.addSubview(textField)
        textField.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: defaultSideInset, bottom: 0, right: defaultSideInset), size: .init(width: 0, height: textFieldHeight))
        textField.centerInSuperview()
        textField.delegate = self
        
        // static message label
        view.addSubview(messageLabel)
        messageLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: textField.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: defaultSideInset, bottom: messageLabelBottomOffset, right: defaultSideInset))
        
        // search buttonn
        view.addSubview(searchButton)
        searchButton.anchor(top: textField.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: searchButtonTopOffset, left: 0, bottom: 0, right: 0), size: .init(width: searchButtonWidth, height: searchButtonHeight))
        searchButton.centerInSuperview(centerInY: false)
    }
    
    /**
     Setup keyboard show/hide notification to scroll screen
     */
    fileprivate func setupKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard notifications
    
    /**
     Calculate and set new Y value of view to scroll screen up with keyboard is shown.
     */
    @objc func keyboardWillBeShown(note: Notification) {
        let userInfo = note.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        // calculate scroll height based on max-y position of 'search button'
        let maxY = view.frame.height - searchButton.frame.origin.y - searchButton.frame.height
        let difference = keyboardFrame.height - maxY
        
        // scroll screen up (set view with new Y value)
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8) // 8 to add extra padding between last screen item and the keyboard
    }
    
    /**
     Reset Y position back to original value when keyboard is hidden
     */
    @objc func keyboardWillBeHidden(note: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
        
    }
}

extension SearchController: UITextFieldDelegate {
    // handle 'Search' button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        
        handleSearch()
        
        return true
    }
}
