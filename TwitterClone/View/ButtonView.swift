//
//  ButtonView.swift
//  TwitterClone
//
//  Created by Felipe Vieira Lima on 30/03/23.
//

import UIKit

class Button: UIButton {
    var spinner = UIActivityIndicatorView()
    var isLoading = false {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        spinner.hidesWhenStopped = true
        spinner.color = .twitterBlue
        spinner.style = .medium
        
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func updateView() {
        if isLoading {
            spinner.startAnimating()
            titleLabel?.alpha = 0
            imageView?.alpha = 0
            titleLabel?.removeFromSuperview()
            imageView?.removeFromSuperview()
            isEnabled = false
        } else {
            spinner.stopAnimating()
            addTitleAndImage()
            titleLabel?.alpha = 1
            imageView?.alpha = 1
            
            isEnabled = true
        }
    }
    
    func addTitleAndImage() {
        if let titleLabel = titleLabel, let imageView = imageView {
            addSubview(titleLabel)
            addSubview(imageView)
        }
    }
}
