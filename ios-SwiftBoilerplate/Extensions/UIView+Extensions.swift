//
//  UIView+Extensions.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/15/20.
//

import UIKit

extension UIView {
    
    /// Helper function to easily instantiate a view.
    class func fromNib() -> UIView? {
        guard let selfView = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)![0] as? UIView else {
            return nil
        }
        return selfView
    }
    
    /// Sets the corner radius of the view based on its width.
    func cornerRadius() {
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}

/// Loading activiy indicator extension.
extension UIView {
    static let loadingViewTag = 1938123987
    
    func showLoading(style: UIActivityIndicatorView.Style = .gray, color: UIColor? = .white, scale: CGFloat = 1) {
    
        let loading = UIActivityIndicatorView(style: style)
        loading.tag = UIView.loadingViewTag
        if let color = color {
        loading.color = color
        }

        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.startAnimating()
        loading.hidesWhenStopped = true
        addSubview(loading)
        loading.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func hideLoading() {
        let loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        loading?.stopAnimating()
        loading?.removeFromSuperview()
    }
}
