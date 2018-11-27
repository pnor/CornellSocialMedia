//
//  PictureCollectionViewCell.swift
//  CornellSocialMedia
//
//  Shows messages that are one main picture with a caption
//
//  Created by Phillip OReggio on 11/23/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit
import SnapKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    // UI Elements
    var profileIcon : UIImageView!
    var nametag : UILabel!
    var image : UIImageView!
    var caption : UILabel!
    
    // Position and Size Constants
    let iconSize = 100
    let padding = 20
    let smallPadding = 10
    
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
        
        image = UIImageView()
        image.bounds = CGRect(x: 0, y: 0, width: contentView.bounds.width - CGFloat(padding * 2), height: contentView.bounds.height - CGFloat((padding * 3) - (smallPadding) - iconSize))
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        contentView.addSubview(image)
    
        caption = UILabel()
        contentView.addSubview(caption)
        
        updateConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    // MARK: - Display
    func configure(with post: Post) {
        profileIcon.image = post.profileImage
        nametag.text = post.name
        if let imageBody = post.image {
            image.image = imageBody
        }
        if let captionText = post.text {
            caption.text = captionText
        }
        
        // DEBUG: This method shouldn't be called if the post lacks an image; a text only message would should be used instead
        assert(post.image != nil)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        profileIcon.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(padding)
            make.leading.equalTo(contentView).offset(padding)
        }
        nametag.snp.makeConstraints { (make) in
            make.leading.equalTo(profileIcon).offset(padding)
            make.centerX.equalTo(profileIcon)
        }
        caption.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-padding)
            make.leading.equalTo(contentView).offset(padding)
            make.trailing.equalTo(contentView).offset(-padding)
        }
        image.snp.makeConstraints { (make) in
            make.top.equalTo(nametag).offset(padding)
            make.leading.equalTo(contentView).offset(padding)
            make.trailing.equalTo(contentView).offset(padding)
            make.bottom.equalTo(caption).offset(-smallPadding)
        }
    }
}
