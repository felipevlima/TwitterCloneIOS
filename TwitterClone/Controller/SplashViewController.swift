//
//  SplashViewController.swift
//  TwitterClone
//
//  Created by Felipe Vieira Lima on 05/04/23.
//

import UIKit

class SplashViewController: UIViewController {
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "TwitterLogo")
        return imageView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .twitterBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        view.addSubview(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.5, animations: {
            let size = self.view.frame.size.width * 15
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = .white
        })
        
        UIView.animate(withDuration: 0.8, animations: {
            self.imageView.alpha = 0
            
        }, completion: { done in
            if done {
//                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    let mainTabBarVC = MainTabController()
                    mainTabBarVC.modalTransitionStyle = .crossDissolve
                    mainTabBarVC.modalPresentationStyle = .fullScreen
                    self.present(mainTabBarVC, animated: false)
//                })
                
            }
        })
    }
}
