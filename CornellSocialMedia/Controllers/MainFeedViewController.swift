//
//  MainFeedViewController.swift
//  CornellSocialMedia
//
//  Created by Phillip OReggio on 11/22/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit
import Hero
import SnapKit

class MainFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Navigation Bar
    var search : UIBarButtonItem!
    var profile : UIBarButtonItem!
    
    // Main Display
    var messagesCollection : UICollectionView!
    var messagesLayout : UICollectionViewFlowLayout!
    var reuseIdentifier = "messagesReuseIdentifier"
    
    // Refresh Control
    var refreshControl : UIRefreshControl!
    
    // Data displayed
    var posts : [Post]?  // Full of dummy Posts rn until Networking Happens
    var cellHeights : [CGFloat]? // All cell heights for each post
    let maxPosts = 30 // Loaded in memory
    let maxLinesOfTextPost = 10
    let maxLinesOfCaption = 2
    
    // Padding and Sizing
    let padding : CGFloat = 20
    let charactersPerLine = 35 // an estimate
    let lineSize = 24 // also an estimate
    var largestCellHeight : CGFloat = 0
    var smallestCellHeight : CGFloat = 0
    // Usual Message Heights
    let blankMessageHeight : CGFloat = 80
    let textMessageBaseHeight : CGFloat = 80
    let imageCaptionMessageHeight : CGFloat = 350
    let imageMessageHeight : CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: UI Elements
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        title = "Main Feed"
        
        search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearch))
        navigationItem.leftBarButtonItem = search
        
        profile = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(goToProfile))
        navigationItem.rightBarButtonItem = profile
        
        messagesLayout = UICollectionViewFlowLayout()
        messagesLayout.scrollDirection = .vertical
        messagesLayout.minimumInteritemSpacing = 1000000
        messagesLayout.minimumLineSpacing = 0
        messagesLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - CGFloat(padding * 2), height: 350)
        
        messagesCollection = UICollectionView(frame: .zero, collectionViewLayout: messagesLayout)
        messagesCollection.delegate = self
        messagesCollection.dataSource = self
        messagesCollection.alwaysBounceVertical = true
        messagesCollection.backgroundColor = .clear
        messagesCollection.register(MainFeedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(messagesCollection)
        
        // Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        messagesCollection.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        // MARK: Animations
        hero.isEnabled = true
        view.hero.id = "backdrop"
        view.applyGradient(with: [UIColor(hue: 0, saturation: 0.8, brightness: 1, alpha: 1), UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.5)], gradient: .topLeftBottomRight)
        view.backgroundColor = .white
        
        //TODO Get Post Data
        refresh()
        messagesCollection.reloadData()
        
        setupConstraints()
    }
    
    // MARK: - UI Positioning
    func setupConstraints() {
        messagesCollection.snp.makeConstraints { (make) in
            make.edges.edges.equalToSuperview().inset(UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        }
    }
    
    // MARK: - Navigation Bar Button Methods and Refresh
    @objc func goToProfile() {
        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    @objc func goToSearch() {
        let peopleSearch = SearchViewController()
        navigationController?.pushViewController(peopleSearch, animated: true)
    }
    
    @objc func refresh() {
        print("Refresh")
        // Get some posts:
        // Debug Vars
        let useRandomGenerated = false
        let generatedTypes : [Debugging.PostType] = [.short, .medium, .long, .image, .imageCaptionless]
        
        posts = []
        if useRandomGenerated { // random
            for _ in 1...maxPosts {
                posts?.append(Debugging.getPostType(generatedTypes))
            }
        } else { // pre made set
            posts? = Debugging.getDefaultPosts()
        }
        
        // Update all cell heights
        cellHeights = [CGFloat](repeating: 0, count: posts?.count ?? 0)
        print(posts ?? "Nothing...😨")
    }
    
    // MARK: - Collection View Methods
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        if let post = posts?[indexPath.row] {
            cell = messagesCollection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            if let feedCell = cell as? MainFeedCollectionViewCell {
                feedCell.clean()
                feedCell.maxLinesOfTextPost = maxLinesOfTextPost
                feedCell.maxLinesOfCaption = maxLinesOfCaption
                feedCell.configure(with: post)
            }
            return cell
        }
        fatalError("No cell at that postition! IndexPath.row = \(indexPath.row)")
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(String(describing: posts?[indexPath.row])) Should go to another screen")
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        updateCellSizing(height: messagesLayout.estimatedItemSize.height, postAtIndex: indexPath.row)
        return messagesLayout.estimatedItemSize
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        print("Height: \(cellHeights?[section] ?? 0)   nil? \(cellHeights == nil)")
//        print("Section: \(section)")
//        print("returns... \(padding - largestCellHeight - (cellHeights?[section] ?? 0))")
//        return padding + largestCellHeight - (cellHeights?[section] ?? 0)
//    }
    
    // MARK: Display Utility Methods
    /// Updates the largest and smallest variables with passed in parameters. Also updates the list of all cell heights
    func updateCellSizing(height: CGFloat, postAtIndex: Int) {
        cellHeights?[postAtIndex] = height
        smallestCellHeight = min(height, smallestCellHeight)
        largestCellHeight = max(height, largestCellHeight)
    }
    
    //MARK: - Display Utility Methods
    func sizeForPost(post: Post) -> CGSize {
        let width = UIScreen.main.bounds.width - CGFloat(padding * 2)
        
        let textWidth = width - CGFloat(padding * 2)
        
        let textHeight = post.text == nil ? 0 : post.text!.height(withConstrainedWidth: textWidth, font: UIFont.systemFont(ofSize: 17))
        
        let height : CGFloat = MainFeedCollectionViewCell.headerHeight(post: post) + textHeight + MainFeedCollectionViewCell.footerHeight(post: post)
        
        return CGSize(width: width, height: height)
    }
}
