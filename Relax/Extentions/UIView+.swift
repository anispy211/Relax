//
//  UIView+.swift
//  Relax
//
//  Created by Aniruddha Kadam on 24/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    func showLoading() {
        endEditing(true)
        addSubview(UIView.loadingView)
        DispatchQueue.main.async() { [weak self] in
            UIView.loadingView.frame = self!.bounds
            UIView.loadingView.alpha = 1
            UIView.loadingView.startAnimating()
            UIView.loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async() {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    UIView.loadingView.alpha = 0
                }) { (_) in
                UIView.loadingView.removeFromSuperview()
                UIView.loadingView.stopAnimating()
                
            }
        }
    }
    
    /// Generically initializes a UIView from a nib.
    /// The generated class will conform to type T
    /// where T is the class used at the time of generating
    ///
    /// Usage:
    ///
    /// `
    /// UIView().initView(named: "MyNib")
    /// `
    /// - Parameter named: The name of the nib to use
    /// - Parameter bundle: The name of the bundle to use. If no bundle is specified will use default.
    public class func initView<T: UIView>(fromNib named: String, bundle: Bundle = Bundle.main) -> T {
        let nib = UINib(nibName: named, bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as! T
    }
    
    func addBorder(withColor color: UIColor, borderWidht: CGFloat = 1.0, cornerRadius: CGFloat = 0.0, clipToBounds: Bool = true) {
        layer.cornerRadius = cornerRadius
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidht
        layer.cornerRadius = cornerRadius
        clipsToBounds = clipToBounds
    }
    
    func addShadow(color: UIColor, shadowRadiusValue: CGFloat, shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0), shadowOpacity: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = shadowRadiusValue
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
    }
    
    func addLine(color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        
        let metrics = ["width": NSNumber(value: width)]
        let views = ["lineView": lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
}
