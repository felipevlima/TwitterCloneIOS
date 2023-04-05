//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Felipe Vieira Lima on 05/04/23.
//

import Foundation
import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: "following")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 10, text: "followers")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
