//
//  FeedController.swift
//  TwitterClone
//
//  Created by Felipe Vieira Lima on 28/03/23.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {
    // MARK: - Properties
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    private let refreshControl = UIRefreshControl()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isHidden = false
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets.reversed()
        }
    }

    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
//        configureTabBarToOldStyle()
        configureNavigationBarToOldStyle()
    }
    
    @objc func didPullToRefresh(_ sender: Any) {
        fetchTweets()
        refreshControl.endRefreshing()
    }
    
    func configureNavigationBarToOldStyle() {
        let apperanceNavBar = UINavigationBarAppearance()
        apperanceNavBar.configureWithOpaqueBackground()
        apperanceNavBar.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = apperanceNavBar
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    func configureTabBarToOldStyle() {
        let apperanceTabBar = UITabBarAppearance()
        apperanceTabBar.configureWithOpaqueBackground()
        apperanceTabBar.backgroundColor = .white
        Utilities().setTabBarItemColors(apperanceTabBar.stackedLayoutAppearance)
        tabBarController?.tabBar.standardAppearance = apperanceTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        let profileImageView = UIImageView()
//        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    

}

// MARK: - UICollectionViewDelegate/DataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let controller = ProfileController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 72)
    }
}

// MARK: - Delegate
extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped() {
//        print("DEBUG: Handle Profile Tapped")
        let controller = ProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
}
