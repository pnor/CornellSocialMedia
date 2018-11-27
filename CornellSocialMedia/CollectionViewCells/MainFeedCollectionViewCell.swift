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
    var postType : PostType = .blankPost

    // UI Elements
    var profileIcon : UIImageView!
    var nametag : UILabel!
    var textBody : UILabel?
    var image : UIImageView?
    
    // Position and Size Constants
    public var maxLinesOfTextPost = 1
    public var maxLinesOfCaption = 1
    // All Text Post
    let iconSize = 40
    let padding = 20
    // With Image
    let imagePadding = 30
    let imageSmallPadding = 10
    
    override init(frame: CGRect) {
        // MARK: - Initialize UI Elements
        super.init(frame: frame)
        
        profileIcon = UIImageView()
        profileIcon.image = UIImage(named: "cornellC")
        profileIcon.bounds = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        profileIcon.layer.cornerRadius = profileIcon.bounds.width / 2
        profileIcon.layer.masksToBounds = true
        profileIcon.clipsToBounds = true
        profileIcon.contentMode = .scaleAspectFit
        contentView.addSubview(profileIcon)
        
        nametag = UILabel()
        nametag.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(nametag)
        
        contentView.applyGradient(with: [UIColor(hue: 0, saturation: 0.1, brightness: 1, alpha: 1), UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 1)], gradient: .topLeftBottomRight)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        
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
        profileIcon.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(padding)
            make.leading.equalTo(contentView).offset(padding)
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
                make.leading.equalTo(contentView).offset(padding)
                make.trailing.equalTo(contentView).offset(-padding)
                make.bottom.equalTo(contentView).offset(-padding)
            }
        } else { // image + blank posts
            textBody?.snp.makeConstraints { (make) in
                make.bottom.equalTo(contentView).offset(-imageSmallPadding)
                make.leading.equalTo(contentView).offset(imagePadding)
                make.trailing.equalTo(contentView).offset(-imagePadding)
            }
            image?.snp.makeConstraints { (make) in
                make.top.equalTo(nametag.snp.bottom).offset(padding)
                make.leading.equalTo(contentView).offset(imagePadding)
                make.trailing.equalTo(contentView).offset(-imagePadding)
                if let textBodyLabel = textBody {
                    make.bottom.equalTo(textBodyLabel.snp.top).offset(-imageSmallPadding)
                } else {
                    make.bottom.equalTo(contentView).offset(-imageSmallPadding)
                }
            }
        }
    }
    
    func configureTextBody(type: PostType, postText: String) {
        switch(type) {
        case .textPost:
            textBody = UILabel()
            if let textBodyLabel = textBody {
                textBodyLabel.backgroundColor = .gray
                textBodyLabel.text = postText
                textBodyLabel.numberOfLines = maxLinesOfTextPost
                textBodyLabel.sizeToFit()
                contentView.addSubview(textBodyLabel)
            }
        case .imagePost:
            textBody = UILabel()
            if let textBodyLabel = textBody {
                textBodyLabel.backgroundColor = .gray
                textBodyLabel.text = postText
                textBodyLabel.numberOfLines = maxLinesOfCaption
                textBodyLabel.sizeToFit()
                contentView.addSubview(textBodyLabel)
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
                contentView.addSubview(postMainImage)
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
                contentView.addSubview(postMainImage)
            }
        default:
            return
        }
    }
    
    // Sets all potentially nil UI Elements to nil so they don't persist when being recycled
    func clean() {
        //textBody?.removeFromSuperview()
        //image?.removeFromSuperview()
        contentView.snp.removeConstraints()
        image?.removeFromSuperview()
        textBody?.removeFromSuperview()
        image = nil
        textBody = nil
    }
}

enum PostType {
    case textPost
    case imagePost
    case imagePostNoCaption
    case blankPost
}
