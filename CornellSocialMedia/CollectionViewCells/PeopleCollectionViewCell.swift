//
//  PeopleCollectionViewCell.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 11/25/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class PeopleCollectionViewCell: UICollectionViewCell {
    
    var peopleNameLabel: UILabel!
    var peopleImage: UIImageView!
    var peopleClassLabel: UILabel!
    var peopleCollegeLabel: UILabel!
    var peopleMajorLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: - UI Elements
        peopleNameLabel = UILabel()
        peopleNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        peopleNameLabel.textColor = .white
        contentView.addSubview(peopleNameLabel)
        
        peopleImage = UIImageView()
        peopleImage.contentMode = .scaleAspectFill
        peopleImage.layer.borderWidth = 1
        peopleImage.layer.borderColor = UIColor.white.cgColor
        peopleImage.layer.cornerRadius = 50
        peopleImage.clipsToBounds = true
        contentView.addSubview(peopleImage)
        
        peopleClassLabel = UILabel()
        peopleClassLabel.font = UIFont.systemFont(ofSize: 18)
        peopleClassLabel.textColor = .white
        contentView.addSubview(peopleClassLabel)
        
        peopleCollegeLabel = UILabel()
        //peopleCollegeLabel.text = "College of Engineering" //placeholder
        peopleCollegeLabel.font = UIFont.systemFont(ofSize: 18)
        peopleCollegeLabel.textColor = .white
        contentView.addSubview(peopleCollegeLabel)
        
        peopleMajorLabel = UILabel()
        //peopleMajorLabel.text = "Computer Science" //placeholder
        peopleMajorLabel.font = UIFont.systemFont(ofSize: 18)
        peopleMajorLabel.textColor = .white
        contentView.addSubview(peopleMajorLabel)
        
        //MARK: Background
        contentView.backgroundColor = UIColor(displayP3Red: 100/255, green: 10/255, blue: 10/255, alpha: 1.0)
    }
    
    override func updateConstraints() {
        
        peopleNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(25)
            make.width.equalTo(375)
            make.height.equalTo(24)
        }
        
        peopleImage.snp.makeConstraints { (make) in
            make.top.equalTo(peopleNameLabel).offset(30)
            make.left.equalTo(contentView).offset(25)
            make.height.width.equalTo(100)
        }
        
        peopleClassLabel.snp.makeConstraints { (make) in
            make.top.equalTo(peopleImage)
            make.left.equalTo(peopleNameLabel).offset(120)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        peopleCollegeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(peopleClassLabel).offset(40)
            make.left.equalTo(peopleClassLabel)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        peopleMajorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(peopleCollegeLabel).offset(40)
            make.left.equalTo(peopleCollegeLabel)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        super.updateConstraints()
    }
    
    func configure(with person: People){
        peopleNameLabel.text = person.name
        peopleImage.image = person.photo
        peopleClassLabel.text = "Class of \(person.classOf!)"
        peopleCollegeLabel.text = person.college
        peopleMajorLabel.text = person.major
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
