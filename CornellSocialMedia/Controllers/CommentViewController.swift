//
//  ViewController.swift
//  CornellSocialMedia
//
//  Created by Phillip OReggio on 12/2/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Parameters
    
    // UI Elements
    var commentsCollectionView : UICollectionView! = nil
    let reuseIdentfier = "reuse"
    var refreshControl : UIRefreshControl!
    var postButton : UIButton!
    var dividingLine : UIView!
    var commentsLabel : UILabel!
    
    // The Original Post
    private var mainPost : Post!
    private var mainPostType : PostType!
    var backgroundSquare : UIView!
    var animationID : String?
    var profileImage : UIImageView!
    var nametag : UILabel!
    var postImage : UIImageView?
    var postTextBody : UILabel?
    
    // Stored Data
    var comments : [Post]? /// Posts that never have images

    // Spacing
    let padding : CGFloat = 20
    let iconSize : CGFloat = 40
    let imagePadding : CGFloat = 30
    let imageSmallPadding : CGFloat = 10
    let imageHeight : CGFloat = 100
    let imageWidth : CGFloat = 130
    let mainPostMaxHeight : CGFloat = 230
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Original Post
        backgroundSquare = UIView()
        backgroundSquare.backgroundColor = .white
        backgroundSquare.layer.cornerRadius = 5
        backgroundSquare.layer.masksToBounds = true
        view.addSubview(backgroundSquare)
        
        nametag = UILabel()
        nametag.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nametag.text = mainPost.name
        backgroundSquare.addSubview(nametag)
        
        profileImage = UIImageView()
        profileImage.image = mainPost.profileImage
        profileImage.bounds = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImage.layer.masksToBounds = true
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFit
        profileImage.backgroundColor = .black
        backgroundSquare.addSubview(profileImage)
        
        if let textBody = mainPost.text {
            postTextBody = UILabel()
            if let postsTextBody = postTextBody {
                postsTextBody.text = textBody
                postsTextBody.numberOfLines = 6
                postsTextBody.font = UIFont.systemFont(ofSize: 17)
                backgroundSquare.addSubview(postsTextBody)
            }
        }
        
        if let image = mainPost.image {
            postImage = UIImageView()
            postTextBody?.numberOfLines = 1
            if let postsImage = postImage {
                postsImage.bounds = CGRect(x: 0, y: 0, width: backgroundSquare.bounds.width - CGFloat(imagePadding * 2), height: backgroundSquare.bounds.height - CGFloat((imagePadding * 3) - (imageSmallPadding) - iconSize))
                postsImage.layer.cornerRadius = 5
                postsImage.layer.masksToBounds = true
                postsImage.clipsToBounds = true
                postsImage.contentMode = .scaleAspectFit
                postsImage.backgroundColor = .black
                postsImage.image = image
                backgroundSquare.addSubview(postsImage)
            }
        }
        
        // Post Button
        postButton = UIButton()
        postButton.setTitle("Post", for: .normal)
        postButton.addTarget(self, action: #selector(post), for: .touchDown)
        postButton.setTitleColor(.red, for: .normal)
        postButton.layer.cornerRadius = 5
        postButton.layer.masksToBounds = true
        postButton.backgroundColor = .white
        view.addSubview(postButton)
        
        // Dividing Line
        dividingLine = UIView()
        dividingLine.backgroundColor = .white
        view.addSubview(dividingLine)
        
        // Comments Label
        commentsLabel = UILabel()
        commentsLabel.text = "Comments"
        commentsLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        commentsLabel.textColor = .white
        view.addSubview(commentsLabel)
        
        // Comments Collection View
        let commentsFlowLayout = UICollectionViewFlowLayout()
        commentsFlowLayout.scrollDirection = .vertical
        commentsFlowLayout.minimumLineSpacing = padding
        commentsFlowLayout.minimumInteritemSpacing = 10000
        
        commentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: commentsFlowLayout)
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.alwaysBounceVertical = true
        commentsCollectionView.backgroundColor = .clear
        commentsCollectionView.register(MainFeedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentfier)
        view.addSubview(commentsCollectionView)
        
        // Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        if #available(iOS 10.0, *) {
            commentsCollectionView.refreshControl = refreshControl
        } else {
            commentsCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // Swiping
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        // Background
        view.applyGradient(with: [
            UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.3),
            UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.9)],
                           gradient: GradientOrientation.topLeftBottomRight)
        view.backgroundColor = .white
        
        // get comments
        refresh()
        
        // Animations
        view.hero.isEnabled = true
        view.hero.id = "backdrop"
        backgroundSquare.hero.id = animationID
        commentsCollectionView.hero.modifiers = [.translate(y: 100)]
        commentsLabel.hero.modifiers = [.translate(y: 100)]
        postButton.hero.modifiers = [.translate(y: 100)]
        dividingLine.hero.modifiers = [.translate(y: 100)]
        
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundSquare.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(padding / 3)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - padding * 2)
            let size = sizeForPost(post: mainPost)
            make.height.equalTo(CGSize(width: size.width, height: min(size.height, self.mainPostMaxHeight)))
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(padding / 2)
            make.size.equalTo(iconSize)
        }
        
        nametag.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImage.snp.trailing).offset(padding)
            make.centerY.equalTo(profileImage)
        }
        
        if mainPostType == .textPost { // text posts
            postTextBody?.snp.makeConstraints { (make) in
                make.top.equalTo(profileImage.snp.bottom).offset(padding)
                make.leading.trailing.equalToSuperview().inset(padding)
                make.bottom.equalToSuperview().offset(-padding)
            }
        } else if mainPostType == .imagePost || mainPostType == .imagePostNoCaption { // image posts
            postTextBody?.snp.makeConstraints { (make) in
                make.top.equalTo(nametag.snp.bottom).offset(imageSmallPadding * 2)
                make.leading.equalToSuperview().offset(padding)
                make.trailing.equalToSuperview().offset(-padding)
            }
            postImage?.snp.makeConstraints { (make) in
                if let text = postTextBody {
                    make.top.equalTo(text.snp.bottom).offset(padding)
                } else {
                    make.top.equalTo(nametag.snp.bottom).offset(padding)
                }
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-imagePadding)
            }
        } else { // blank posts
            backgroundSquare.snp.makeConstraints { (make) in
                make.height.equalTo(80)
            }
        }
        
        commentsLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.top.equalTo(backgroundSquare.snp.bottom).offset(padding)
            make.width.equalTo(100)
        }
        
        postButton.snp.makeConstraints { (make) in
            make.leading.equalTo(commentsLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(commentsLabel)
            make.height.equalTo(30)
        }
        
        dividingLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(commentsLabel.snp.bottom).offset(10)
        }
        
        commentsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(dividingLine.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Handling Swipes
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .down:
                navigationController?.popViewController(animated: true)
            default:
                print("Swiped in a unhandled direction")
            }
        }
    }
    
    // MARK: - Initializing with Data
    func setCell(with post: Post) {
        self.mainPost = post
        self.mainPostType =
            (post.image == nil && post.text == nil) ? PostType.blankPost : // blank
            (post.image == nil) ? PostType.textPost : // text
            (post.text == nil) ? PostType.imagePostNoCaption : PostType.imagePost // images
    }
    
    func setAnimationData(with indexPath: IndexPath) {
        animationID = "Post\(indexPath.row)"
    }
    
    // MARK: - Methods called from UI Elements
    @objc func refresh() {
        // Update all cell heights
        let timer = Timer(timeInterval: 3.0, repeats: false, block: { (timer) in
            DispatchQueue.main.async {
                self.comments = self.getSampleComments(amount: (1...20).randomElement()!)
                self.commentsCollectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
        timer.fire()
    }
    
    @objc func post() {
        var postViewController = PostViewController()
        postViewController.allowsImagePosting = true
        postViewController.fromComments = true
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    // MARK: - Debugging
    func getSampleComments(amount: Int) -> [Post] {
        var curPosts : [Post] = []
        for _ in 1...amount {
            curPosts.append(Debugging.getPostType([.short, .medium, .long]))
        }
        return curPosts
    }
    // MARK: - Collection View Methods
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        if let post = comments?[indexPath.row] {
            cell = commentsCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentfier, for: indexPath)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let comment = comments?[indexPath.row] {
            return sizeForPost(post: comment)
        }
        fatalError("no post for this position!")
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
