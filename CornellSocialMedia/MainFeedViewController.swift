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
    
    // Padding
    let padding : CGFloat = 20
    let messageHeight : CGFloat = 200
    let imageMessageHeight : CGFloat = 300
    let blankMessageHeight : CGFloat = 130

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: UI Elements
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = true
        title = "Main Feed"
        
        search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearch))
        navigationItem.leftBarButtonItem = search
        
        profile = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(goToProfile))
        navigationItem.rightBarButtonItem = profile
        
        let messageLayout = UICollectionViewFlowLayout()
        messageLayout.scrollDirection = .vertical
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
            make.edges.equalTo(view)
        }
    }
    
    // MARK: - Navigation Bar Button Methods and Refresh
    @objc func goToProfile() {
        print("Gonna go to the profile")
    }
    
    @objc func goToSearch() {
        print("Going to Search")
    }
    
    @objc func refresh() {
        print("Refresh")
        // Debugging: Initialize Posts with random data
        posts = []
        for _ in 1...maxPosts {
            posts?.append(Debugging.randomPost())
        }
        
        print(posts!)
    }
    
    // MARK: - Collection View Methods
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        let post = posts?[indexPath.row]
        
        cell = messagesCollection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let feedCell = cell as? MainFeedCollectionViewCell {
            if let curPost = post {
                feedCell.configure(with: curPost)
            }
        }
            
        return cell
    }
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(posts?[indexPath.row]) Should go to another screen")
        return
    }
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if posts?[indexPath.row].text == nil && posts?[indexPath.row].image == nil { // A Blank Post
            return CGSize(width: UIScreen.main.bounds.width - CGFloat(padding * 2), height: blankMessageHeight)
        }
        
        return CGSize(width: UIScreen.main.bounds.width - CGFloat(padding * 2), height: posts?[indexPath.row].image == nil ? messageHeight : imageMessageHeight)
    }
}




// MARK: - Debug: Make Random Posts
// For various Debugging Purposes and providing Default Values
class Debugging {
    // Settings
    static let onlyShowNormalPosts = false
    
    static func randomPost() -> Post {
        switch (randomPostType) {
            case .short:
                return Post(name: randomWord, profileImage: getRandomImage(), body: randomSentence(word: (3...12).randomElement()!))
            case.medium:
            return Post(name: randomWord, profileImage: getRandomImage(), body: randomSentence(word: (20...60).randomElement()!))
            case .long:
            return Post(name: randomWord, profileImage: getRandomImage(), body: randomSentence(word: (80...120).randomElement()!))
            case .image:
                return Post(name: randomWord, profileImage: getRandomImage(), image: getRandomImage())
            case .imageCaptionless:
                return Post(name: randomWord, profileImage: getRandomImage(), image: getRandomImage())
            case .noBody:
                return Post(name: randomWord, profileImage: getRandomImage())
        }
    }
    
    //MARK: Random Text Generation
    private static var randomWord : String {
        get {
            let availableWords = [
                "Lorem",
                "Ipsum",
                "Dolor",
                "Sit",
                "Amet",
                "Vu",
                "Vitae",
                "Oportaet",
                "Occuret",
                "Eam",
                "Alli"
            ]
            return availableWords.randomElement()!
        }
    }
    
    private static func randomSentence(word: Int) -> String {
        var str = ""
        for _ in 1...word {
            str.append(randomWord + " ")
        }
        return str
    }
    
    // MARK: Random Image
    private static func getRandomImage() -> UIImage{
        let possibleImages = [
            "cornellC",
            "cornell1",
            "cornell2"
        ]
        return UIImage(named: possibleImages.randomElement()!)!
    }
    
    // MARK: Random Post Type
    private static var randomPostType : PostType {
        get {
            return PostType(rawValue: onlyShowNormalPosts ?
                (1...5).randomElement() ?? 1 :
                (1...6).randomElement() ?? 1)!
        }
    }
    
    enum PostType : Int {
        // Normal Posts
        case short = 1 // A short text post
        case medium = 2 // A medium text post
        case long = 3 // A long text post
        case image = 4 // An Image Post with a caption
        case imageCaptionless = 5 // An Image Post without a caption
        // Wierd stuff
        case noBody = 6 // A Text post with no text (or image)
    }
}
