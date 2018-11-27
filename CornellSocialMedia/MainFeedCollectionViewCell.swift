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
    // All Text Post
    let iconSize = 40
    let padding = 20
    // With Image
    let imageIconSize = 30
    let imagePadding = 20
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
        contentView.layer.cornerRadius = 20
        
        updateConstraints()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    // MARK: - Display
    func configure(with post: Post) {
        if let postText = post.text, post.image == nil { // Text Post
            postType = .textPost
            
            textBody = UILabel()
            textBody?.numberOfLines = 4
            if let textBodyLabel = textBody {
                textBodyLabel.text = postText
                contentView.addSubview(textBodyLabel)
            }
        } else if let postText = post.text, let postImage = post.image { // Image Post
            postType = .imagePost

            textBody = UILabel()
            if let textBodyLabel = textBody {
                textBodyLabel.text = postText
                textBodyLabel.numberOfLines = 1
                contentView.addSubview(textBodyLabel)
            }
            
            image = UIImageView()
            image?.bounds = CGRect(x: 0, y: 0, width: contentView.bounds.width - CGFloat(imagePadding * 2), height: contentView.bounds.height - CGFloat((imagePadding * 3) - (imageSmallPadding) - iconSize))
            image?.layer.cornerRadius = 20
            image?.layer.masksToBounds = true
            image?.clipsToBounds = true
            image?.contentMode = .scaleAspectFit
            if let postMainImage = image {
                postMainImage.image = postImage
                contentView.addSubview(postMainImage)
            }
        } else if let postImage = post.image, post.text == nil {
            postType = .imagePost

            image = UIImageView()
            image?.bounds = CGRect(x: 0, y: 0, width: contentView.bounds.width - CGFloat(imagePadding * 2), height: contentView.bounds.height - CGFloat((imagePadding * 3) - (imageSmallPadding) - iconSize))
            image?.layer.cornerRadius = 20
            image?.layer.masksToBounds = true
            image?.clipsToBounds = true
            image?.contentMode = .scaleAspectFit
            if let postMainImage = image {
                postMainImage.image = postImage
                contentView.addSubview(postMainImage)
            }
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
            make.leading.equalTo(profileIcon).offset(padding)
            make.centerX.equalTo(profileIcon)
        }
        
        if postType == .textPost {
            textBody?.snp.makeConstraints { (make) in
                make.top.equalTo(nametag).offset(padding)
                make.leading.equalTo(contentView).offset(padding)
                make.trailing.equalTo(contentView).offset(padding)
                make.bottom.equalTo(contentView).offset(padding)
            }
        } else {
            textBody?.snp.makeConstraints { (make) in
                make.bottom.equalTo(contentView).offset(-imagePadding)
                make.leading.equalTo(contentView).offset(imagePadding)
                make.trailing.equalTo(contentView).offset(-imagePadding)
            }
            image?.snp.makeConstraints { (make) in
                make.top.equalTo(nametag).offset(padding)
                make.leading.equalTo(contentView).offset(imagePadding)
                make.trailing.equalTo(contentView).offset(-imagePadding)
                if let textBodyLabel = textBody {
                    make.bottom.equalTo(textBodyLabel).offset(-imageSmallPadding)
                }
            }
        }
    }
}

enum PostType {
    case textPost
    case imagePost
    case blankPost
}
