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
    var reuseIdentifier = "messagesReuseIdentifier"
    
    // Refresh Control
    var refreshControl : UIRefreshControl!
    
    // Data displayed
    var posts : [Post]?  // Full of dummy Posts rn until Networking Happens
    let maxPosts = 30 // Loaded in memory
    let maxLinesOfTextPost = 10
    let maxLinesOfCaption = 1
    
    // Padding and Sizing
    let padding : CGFloat = 20
    let messageBaseheight : CGFloat = 80 // accounts for nametag and profile icon
    let imageMessageBaseHeight : CGFloat = 240 // accounts for nametag, icon, and picture
    let blankMessageHeight : CGFloat = 130
    let charactersPerLine = 35 // an estimate
    let lineSize = 24 // also an estimate

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: UI Elements
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .red
        title = "Main Feed"
        
        search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearch))
        navigationItem.leftBarButtonItem = search
        
        profile = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(goToProfile))
        navigationItem.rightBarButtonItem = profile
        
        let messageLayout = UICollectionViewFlowLayout()
        messageLayout.scrollDirection = .vertical
        messageLayout.minimumLineSpacing = padding
        messageLayout.minimumInteritemSpacing = 1000000
        
        messagesCollection = UICollectionView(frame: .zero, collectionViewLayout: messageLayout)
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
        print("Going to Search")
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
        print(posts ?? "Nothing...😨")
    }
    
    // MARK: - Collection View Methods
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
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
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let post = posts?[indexPath.row] {
            print("At indexPath: \(indexPath.row)")
            return sizeForPost(post: post)
        }
        fatalError("the post index was outta bounds!")
    }
    
    
    //MARK: - Display Utility Methods
    func sizeForPost(post: Post) -> CGSize {
        if post.text == nil && post.image == nil { // A Blank Post
            return CGSize(width: UIScreen.main.bounds.width - CGFloat(padding * 2), height: blankMessageHeight)
        }
        
        let textHeight : CGFloat
        if post.image == nil { // text post
            textHeight = CGFloat(((1...maxLinesOfTextPost).clamp((post.text?.count ?? 0) / charactersPerLine) + 1) * lineSize)
        } else { // image post
            textHeight = CGFloat(( (1...maxLinesOfCaption).clamp((post.text?.count ?? 0) / charactersPerLine) + 1) * lineSize)
        }
        
        let size = CGSize(width: UIScreen.main.bounds.width - CGFloat(padding * 2),
                          height: post.image == nil ?
                            messageBaseheight + textHeight : // text post height
                            imageMessageBaseHeight + textHeight) // image post height
        return size
    }
}

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}
