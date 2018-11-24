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
    // UI Elements
    var profileIcon : UIImageView!
    var nametag : UILabel!
    var textBody : UILabel!
    var image : UIImageView!
    var hasImage : Bool = true
    
    // Position and Size Constants
    // All Text Post
    let iconSize = 100
    let padding = 20
    // With Image
    let imageIconSize = 100
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
        
        textBody = UILabel()
        textBody.numberOfLines = 0
        contentView.addSubview(textBody)
        
        image = UIImageView()
        image.bounds = CGRect(x: 0, y: 0, width: contentView.bounds.width - CGFloat(imagePadding * 2), height: contentView.bounds.height - CGFloat((imagePadding * 3) - (imageSmallPadding) - iconSize))
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        contentView.addSubview(image)
        
        contentView.applyGradient(with: [UIColor(hue: 0, saturation: 0.1, brightness: 1, alpha: 1), UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 1)], gradient: .topLeftBottomRight)
        updateConstraints()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    // MARK: - Display
    func configure(with post: Post) {
        profileIcon.image = post.profileImage
        nametag.text = post.name
        if let messageBody = post.text {
            textBody.text = messageBody
        }
        if let imageBody = post.image {
            image.image = imageBody
        }
        
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
        textBody.snp.makeConstraints { (make) in
            make.top.equalTo(nametag).offset(padding)
            make.leading.equalTo(contentView).offset(padding)
            make.trailing.equalTo(contentView).offset(padding)
            make.bottom.equalTo(contentView).offset(padding)
        }
        
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
