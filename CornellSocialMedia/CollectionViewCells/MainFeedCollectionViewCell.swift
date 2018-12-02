//
//  TextCollectionViewCell.swift
//  CornellSocialMedia
//
//  Shows messages that on the main feed
//
//  Created by Phillip OReggio on 11/23/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit
import SnapKit

class MainFeedCollectionViewCell: UICollectionViewCell {

    // MARK: - Parameters
    var containerView : UIView!
    var postType : PostType = .blankPost

    // UI Elements
    var profileIcon : UIImageView!
    var nametag : UILabel!
    var textBody : UILabel?
    var image : UIImageView?
    
    // Position and Size Constants
    public var maxLinesOfTextPost = 0
    public var maxLinesOfCaption = 0
    // All Text Post
    let iconSize = 40
    let padding = 20
    // With Image
    let imagePadding = 30
    let imageSmallPadding = 10
    let imageHeight = 200
    
    override init(frame: CGRect) {
        // MARK: - Initialize UI Elements
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clear
        contentView.layer.masksToBounds = true
        
        // Second to back view
        containerView = UIView()
        containerView.layer.cornerRadius = 5
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
        
        profileIcon = UIImageView()
        profileIcon.image = UIImage(named: "cornellC")
        profileIcon.bounds = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        profileIcon.layer.cornerRadius = profileIcon.bounds.width / 2
        profileIcon.layer.masksToBounds = true
        profileIcon.clipsToBounds = true
        profileIcon.contentMode = .scaleAspectFit
        profileIcon.backgroundColor = .black
        containerView.addSubview(profileIcon)
        
        nametag = UILabel()
        nametag.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        containerView.addSubview(nametag)
        
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    // MARK: - Display
    func configure(with post: Post) {
        if let postText = post.text, post.image == nil { // Text Post
            postType = .textPost
            configureTextBody(type: .textPost, postText: postText)
        } else if let postText = post.text, let postImage = post.image { // Image Post with Caption
            postType = .imagePost

            configureTextBody(type: .imagePost, postText: postText)
            configureImage(type: .imagePost, mainImage: postImage)
        } else if let postImage = post.image, post.text == nil { // Image Post no Caption
            postType = .imagePostNoCaption
            configureImage(type: .imagePostNoCaption, mainImage
                : postImage)
        } else { // Nothing at all
            postType = .blankPost
        }
        
        profileIcon.image = post.profileImage
        nametag.text = post.name
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()

        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - CGFloat(padding * 2))
        }
        
        profileIcon.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalToSuperview().offset(padding)
            make.size.equalTo(iconSize)
        }
        nametag.snp.makeConstraints { (make) in
            make.leading.equalTo(profileIcon.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.centerY.equalTo(profileIcon)
        }
        
        if postType == .textPost { // text posts
            textBody?.snp.makeConstraints { (make) in
                make.top.equalTo(profileIcon).offset(3 * padding)
                make.leading.trailing.equalToSuperview().inset(padding)
                make.bottom.equalToSuperview().offset(-padding)
            }
        } else if postType == .imagePost || postType == .imagePostNoCaption { // image posts
            textBody?.snp.makeConstraints { (make) in
                make.top.equalTo(nametag.snp.bottom).offset(imageSmallPadding * 2)
                make.leading.equalToSuperview().offset(padding)
                make.trailing.equalToSuperview().offset(-padding)
            }
            image?.snp.makeConstraints { (make) in
                if let text = textBody {
                    make.top.equalTo(text.snp.bottom).offset(padding)
                } else {
                    make.top.equalTo(nametag.snp.bottom).offset(padding)
                }
                make.leading.equalToSuperview().offset(imagePadding)
                make.trailing.equalToSuperview().offset(-imagePadding)
                make.height.equalTo(imageHeight)
                make.bottom.equalToSuperview().offset(-imagePadding)
            }
        } else { // blank posts
            contentView.snp.makeConstraints { (make) in
                make.height.equalTo(80)
            }
        }
    }
    
    func configureTextBody(type: PostType, postText: String) {
        switch(type) {
        case .textPost:
            textBody = UILabel()
            if let textBodyLabel = textBody {
                textBodyLabel.text = postText
                textBodyLabel.numberOfLines = maxLinesOfTextPost
                textBodyLabel.font = UIFont.systemFont(ofSize: 17)
                //textBodyLabel.sizeToFit()
                containerView.addSubview(textBodyLabel)
            }
        case .imagePost:
            textBody = UILabel()
            if let textBodyLabel = textBody {
                textBodyLabel.text = postText
                textBodyLabel.numberOfLines = maxLinesOfCaption
                textBodyLabel.font = UIFont.systemFont(ofSize: 17)
                //textBodyLabel.sizeToFit()
                containerView.addSubview(textBodyLabel)
            }
        default:
            return
        }
    }
    
    func configureImage(type: PostType, mainImage: UIImage) {
        switch(type) {
        case .imagePost:
            image = UIImageView()
            image?.bounds = CGRect(x: 0, y: 0, width: contentView.bounds.width - CGFloat(imagePadding * 2), height: contentView.bounds.height - CGFloat((imagePadding * 3) - (imageSmallPadding) - iconSize))
            image?.layer.cornerRadius = 5
            image?.layer.masksToBounds = true
            image?.clipsToBounds = true
            image?.contentMode = .scaleAspectFit
            image?.backgroundColor = .black
            if let postMainImage = image {
                postMainImage.image = mainImage
                containerView.addSubview(postMainImage)
            }
        case .imagePostNoCaption:
            image = UIImageView()
            image?.bounds = CGRect(x: 0, y: 0, width: contentView.bounds.width - CGFloat(imagePadding * 2), height: contentView.bounds.height - CGFloat((imagePadding * 3) - (imageSmallPadding) - iconSize))
            image?.layer.cornerRadius = 5
            image?.layer.masksToBounds = true
            image?.clipsToBounds = true
            image?.contentMode = .scaleAspectFit
            image?.backgroundColor = .black
            if let postMainImage = image {
                postMainImage.image = mainImage
                containerView.addSubview(postMainImage)
            }
        default:
            return
        }
    }
    
    // Sets all potentially nil UI Elements to nil so they don't persist when being recycled
    func clean() {
        contentView.snp.removeConstraints()
        image?.removeFromSuperview()
        textBody?.removeFromSuperview()
        image = nil
        textBody = nil
    }
    
    // MARK: - Header and Footer Calculators
    /// Everything from the top to the text/image
    static func headerHeight(post: Post) -> CGFloat {
        // From Parameters
        // All Text Post
        let iconSize = 40
        let padding = 20
        // With Image
        let imagePadding = 30
        let imageSmallPadding = 10
        let imageHeight = 200
        
        
        switch getPostType(from: post) {
        case .textPost:
        return CGFloat(padding + iconSize + (3 * padding))
        case .imagePost:
        return CGFloat(padding + iconSize + (2 * imageSmallPadding))
        case .imagePostNoCaption:
        return CGFloat(padding + iconSize + padding)
        case .blankPost:
        return CGFloat(2 * padding + iconSize)
        }
    }
    
    static func footerHeight(post: Post) -> CGFloat  { /// Everything below the text
        // From Parameters...
        // All Text Post
        let iconSize = 40
        let padding = 20
        // With Image
        let imagePadding = 30
        let imageSmallPadding = 10
        let imageHeight = 200
        
        
        switch getPostType(from: post) {
        case .textPost:
            return CGFloat(padding)
        case .imagePost:
            return CGFloat(padding + imageHeight + imagePadding)
        case .imagePostNoCaption:
            return CGFloat(imageHeight + imagePadding)
        case .blankPost:
            return CGFloat(0)
        }
    }
    
    // MARK: - Helper Methods
    static func getPostType(from post: Post) -> PostType {
        if post.text == nil && post.image == nil {
            return PostType.blankPost
        }
        
        if post.image == nil {
            return PostType.textPost
        } else {
            return post.text == nil ? PostType.imagePostNoCaption : PostType.imagePost
        }
    }
}

enum PostType {
    case textPost
    case imagePost
    case imagePostNoCaption
    case blankPost
}
