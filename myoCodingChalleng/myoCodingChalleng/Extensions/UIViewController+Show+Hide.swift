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
    func showLoadingView(onView view: UIView) {
        // need to substract status bar and nav bar height in order to have the loading wheel at the center.
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let searchBarHeight: CGFloat = 56
        let loadingView = UIView(frame: CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width, height: view.frame.height - statusBarHeight - searchBarHeight - (navBarHeight ?? 0))))
        loadingView.tag = 42
        loadingView.backgroundColor = .white
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingIndicator.center = loadingView.center
        loadingIndicator.color = .black
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)
        view.addSubview(loadingView)
    }
    
    func hideLoadingView(tableView: UITableView) {
        tableView.separatorColor = .lightGray
        tableView.refreshControl?.endRefreshing()
        
        let loadingView = self.view.viewWithTag(42)
        
        UIView.animate(withDuration: 0.25, animations: {
            loadingView?.alpha = 0
        }, completion: { _ in
            loadingView?.removeFromSuperview()
        })
    }
    
    func hideLoadingView(fromView view: UIView) {
        let loadingView = view.viewWithTag(42)
        
        UIView.animate(withDuration: 0.25, animations: {
            loadingView?.alpha = 0
        }, completion: { _ in
            loadingView?.removeFromSuperview()
        })
    }
}
