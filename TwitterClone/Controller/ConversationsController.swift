//
//  ConversationsController.swift
//  TwitterClone
//
//  Created by Felipe Vieira Lima on 28/03/23.
//

import UIKit

class ConversationsController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messagess"
    }
}
