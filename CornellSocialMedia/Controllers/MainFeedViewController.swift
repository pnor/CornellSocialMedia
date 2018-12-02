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
    let maxPosts = 30 // Loaded in memory
    let maxLinesOfTextPost = 0
    let maxLinesOfCaption = 0
    
    // Padding and Sizing
    let padding : CGFloat = 20
    let charactersPerLine = 35 // an estimate
    let lineSize = 22 // also an estimate
    var largestCellHeight : CGFloat = 0
    var smallestCellHeight : CGFloat = 0
    // Usual Message Heights
    let blankMessageHeight : CGFloat = 80
    let textMessageBaseHeight : CGFloat = 80
    let imageMessageBaseHeight : CGFloat = 200
    
    // Transitions / Animations
    var transitionDirection = 0 /// 1 : Right -1 : Left

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: UI Elements
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 27/255, blue: 27/255, alpha: 1.0)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "Main Feed"
        
        search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearch))
        navigationItem.leftBarButtonItem = search
        
        profile = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(goToProfile))
        navigationItem.rightBarButtonItem = profile
        
        messagesLayout = UICollectionViewFlowLayout()
        messagesLayout.scrollDirection = .vertical
        //messagesLayout.minimumInteritemSpacing = 1000000
        messagesLayout.minimumLineSpacing = padding
        //messagesLayout.itemSize = UICollectionView.sizeThatFits()
//        messagesLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - CGFloat(padding * 2), height: 340)
        
        messagesCollection = UICollectionView(frame: .zero, collectionViewLayout: messagesLayout)
        messagesCollection.delegate = self
        messagesCollection.dataSource = self
        messagesCollection.alwaysBounceVertical = true
        messagesCollection.backgroundColor = .clear
        messagesCollection.register(MainFeedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(messagesCollection)
        
        // Swiping
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        if #available(iOS 10.0, *) {
            messagesCollection.refreshControl = refreshControl
        } else {
            messagesCollection.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        // MARK: Animations
        hero.isEnabled = true
        view.hero.id = "backdrop"
        view.applyGradient(with: [
            UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.3),
            UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.6)],
                        gradient: GradientOrientation.topLeftBottomRight)
        view.backgroundColor = .white
        
        //TODO Get Post Data
        posts = getPosts()
        messagesCollection.reloadData()
        
        setupConstraints()
    }
    
    // MARK: - UI Positioning
    func setupConstraints() {
        messagesCollection.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()//.inset(UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        }
    }
    
    // MARK: - Handling Swipes
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                goToSearch()
            case .left:
                goToProfile()
            default:
                print("Swiped in a unhandled direction")
            }
        }
    }
    
    // MARK: - Navigation Bar Button Methods and Refresh
    @objc func goToProfile() {
        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    @objc func goToSearch() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    @objc func refresh() {
        print("Refresh")
        // Update all cell heights
        let timer = Timer(timeInterval: 3.0, repeats: false, block: { (timer) in
            DispatchQueue.main.async {
                self.posts = self.getPosts()
                print("-----")
                print(self.posts ?? "Nothing...😨")
                self.messagesCollection.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
        timer.fire()
    }
    
    func getPosts() -> [Post] {
        // Get some posts:
        // Debug Vars
        let useRandomGenerated = true
        let generatedTypes : [Debugging.PostType] = [.image, .short, .medium, .long]
        
        var curPosts : [Post] = []
        if useRandomGenerated { // random
            for _ in 1...maxPosts {
                curPosts.append(Debugging.getPostType(generatedTypes))
            }
        } else { // pre made set
            curPosts = Debugging.getDefaultPosts()
        }
        return curPosts
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
                feedCell.configure(with: post)
            }
            cell.setNeedsUpdateConstraints()
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
        if let post = posts?[indexPath.row] {
            return sizeForPost(post: post)
            
//            if post.image == nil {
//                return CGSize(width: messagesLayout.estimatedItemSize.width, height: sizeForPost(post: posts![indexPath.row]).height)
//            } else {
//                return messagesLayout.estimatedItemSize
//            }
        }
        fatalError("no post for this position!")
    }
    
    
    //MARK: - Display Utility Methods
    func sizeForPost(post: Post) -> CGSize {
        let width = UIScreen.main.bounds.width - CGFloat(padding * 2)
        let textHeight = post.text == nil ? 0 : post.text!.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 17))
        let height : CGFloat = MainFeedCollectionViewCell.headerHeight(post: post) + textHeight + MainFeedCollectionViewCell.footerHeight(post: post)
        return CGSize(width: width, height: height)
    }
}

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
