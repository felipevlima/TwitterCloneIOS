//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Felipe Vieira Lima on 31/03/23.
//

import UIKit
import SDWebImage

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    // MARK: - Properties
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    var isLiked: Bool = false
    var isRetweeted: Bool = false
    
    weak var delegate: TweetCellDelegate?
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some test caption"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let infoLabel = UILabel()
    
    private let countLikeLabel: UILabel = {
        let label = UILabel()
//        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
//        label.text = "3"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let retweetCountLabel: UILabel = {
        let label = UILabel()
//        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Lifecycler
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.text = "Eddie Brock @venon"
        
        let commentStack = UIStackView(arrangedSubviews: [commentButton, commentCountLabel])
        commentStack.axis = .horizontal
        commentStack.spacing = 4
        commentStack.alignment = .center
        
        let retweetStack = UIStackView(arrangedSubviews: [retweetButton, retweetCountLabel])
        retweetStack.axis = .horizontal
        retweetStack.spacing = 4
        retweetStack.alignment = .center
        
        let likeStack = UIStackView(arrangedSubviews: [likeButton, countLikeLabel])
        likeStack.axis = .horizontal
        likeStack.spacing = 4
        likeStack.alignment = .center
        
        
        let actionStack = UIStackView(arrangedSubviews: [commentStack, retweetStack, likeStack, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 56
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray.withAlphaComponent(0.15)
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleProfileImageTapped() {
//        print("DEBUG: image profile")
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        isRetweeted.toggle()
        
        retweetButton.tintColor = isRetweeted ? .systemGreen : .darkGray
        retweetCountLabel.textColor = isRetweeted ? .systemGreen : .darkGray
    
    }
    
    @objc func handleLikeTapped() {
        isLiked.toggle()
        likeButton.setImage(UIImage(named: isLiked ? "like_filled" : "like"), for: .normal)
        likeButton.tintColor = isLiked ? .systemRed : .darkGray
        countLikeLabel.textColor = isLiked ? .systemRed : .darkGray
    }
    
    @objc func handleShareTapped() {
        
    }
    
    // MARK: - Helpers
    func configure() {
        guard let tweet = tweet else {
            return
        }
        
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        countLikeLabel.text = "\(tweet.likes)"
        retweetCountLabel.text = "\(tweet.retweetCount)"
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        infoLabel.attributedText = viewModel.userInfoText
    }
}
