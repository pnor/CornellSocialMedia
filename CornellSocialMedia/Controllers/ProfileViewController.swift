//
//  ProfileViewController.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 11/25/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {

    // MARK: - Parameters
    // UI Elements
    var nameLabel: UILabel!
    var profileImage: UIImageView!
    var classLabel: UILabel!
    var collegeLabel: UILabel!
    var majorLabel: UILabel!
    var profileNavigator: UISegmentedControl!
    var profileNavigatorView: UICollectionView!
    
    //Collection View Elements
    let peopleReuseIdentifier = "peopleReuseIdentifier"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - UI Elements
        nameLabel = UILabel()
        nameLabel.text = "Gonzalo Gonzalez-Pumariega" //placeholder
        //should auto-resize font when too big to fit
        //not priority feature
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .white
        view.addSubview(nameLabel)
        
        profileImage = UIImageView(image: UIImage(named: "cornell2"))
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        view.addSubview(profileImage)
        
        classLabel = UILabel()
        classLabel.text = "Class of 2022" //placeholder
        classLabel.font = UIFont.systemFont(ofSize: 18)
        classLabel.textColor = .white
        view.addSubview(classLabel)
        
        collegeLabel = UILabel()
        collegeLabel.text = "College of Engineering" //placeholder
        collegeLabel.font = UIFont.systemFont(ofSize: 18)
        collegeLabel.textColor = .white
        view.addSubview(collegeLabel)
        
        majorLabel = UILabel()
        majorLabel.text = "Computer Science" //placeholder
        majorLabel.font = UIFont.systemFont(ofSize: 18)
        majorLabel.textColor = .white
        view.addSubview(majorLabel)
        
        profileNavigator = UISegmentedControl()
        profileNavigator.insertSegment(withTitle: "Post History", at: 0, animated: true)
        profileNavigator.insertSegment(withTitle: "Followers", at: 1, animated: true)
        profileNavigator.insertSegment(withTitle: "Following", at: 2, animated: true)
        profileNavigator.selectedSegmentIndex = 0
        profileNavigator.tintColor = .white
        profileNavigator.addTarget(self, action: #selector(switchView), for: .valueChanged)
        view.addSubview(profileNavigator)
        
        let profileLayout = UICollectionViewFlowLayout()
        profileLayout.scrollDirection = .vertical
        profileLayout.minimumInteritemSpacing = 32
        profileLayout.minimumLineSpacing = 32
        profileNavigatorView = UICollectionView(frame: .zero, collectionViewLayout: profileLayout)
        profileNavigatorView.backgroundColor = view.backgroundColor
        profileNavigatorView.delegate = self
        profileNavigatorView.dataSource = self
        profileNavigatorView.alwaysBounceVertical = true
        profileNavigatorView.register(PeopleCollectionViewCell.self, forCellWithReuseIdentifier: peopleReuseIdentifier)
        view.addSubview(profileNavigatorView)
        
        // MARK: Background
        view.backgroundColor = UIColor(displayP3Red: 100/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(75)
            make.left.equalTo(view).offset(25)
            make.width.equalTo(375)
            make.height.equalTo(24)
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel).offset(50)
            make.left.equalTo(view).offset(25)
            make.height.width.equalTo(100)
        }
        
        classLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImage)
            make.left.equalTo(nameLabel).offset(120)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        collegeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(classLabel).offset(40)
            make.left.equalTo(classLabel)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        majorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(collegeLabel).offset(40)
            make.left.equalTo(collegeLabel)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        profileNavigator.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(majorLabel).offset(50)
            make.height.equalTo(25)
        }
        
        profileNavigatorView.snp.makeConstraints { (make) in
            make.top.equalTo(profileNavigatorView)
            make.width.bottom.equalTo(view)
        }
    }
    
    //MARK: - Segmented Control
    @objc func switchView(){
        switch(profileNavigator.selectedSegmentIndex){
        case 0:
            //Switch to Post History
            break
        case 1:
            //Switch to Followers
            break
        case 2:
            //Switch to Following
            break
        default:
            break
        }
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //todo
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //todo
        return UICollectionViewCell()
    }

}
