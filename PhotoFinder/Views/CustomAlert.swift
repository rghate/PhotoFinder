//
//  CustomAlert.swift
//  PhotoFinder
//
//  Created by Rupali on 18.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

class CustomAlert {
    
    func show(withTitle title: String, message: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}
