//
//  UIViewController+Show+Hide.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 02.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Errors
    func showMessage(withTitle title: String, withMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Loading
    func createLoadingView() -> UIView {
        let loadingView = UIView(frame: CGRect(origin: view.bounds.origin, size: CGSize(width: view.bounds.width, height: view.bounds.height)))
        loadingView.backgroundColor = .white
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingIndicator.center = loadingView.center
        loadingIndicator.color = .black
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)

        return loadingView
    }
}
