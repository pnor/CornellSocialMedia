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
    var profileNameLabel: UILabel!
    var profileImage: UIImageView!
    var profileClassLabel: UILabel!
    var profileCollegeLabel: UILabel!
    var profileMajorLabel: UILabel!
    var profileNavigator: UISegmentedControl!
    var profileNavigatorView: UICollectionView!
    
    //Collection View Elements
    let peopleViewReuseIdentifier = "peopleViewReuseIdentifier"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - UI Elements
        profileNameLabel = UILabel()
        profileNameLabel.text = "Gonzalo Gonzalez-Pumariega" //placeholder
        //should auto-resize font when too big to fit
        //not priority feature
        profileNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        profileNameLabel.textColor = .white
        view.addSubview(profileNameLabel)
        
        profileImage = UIImageView(image: UIImage(named: "cornell2"))
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        view.addSubview(profileImage)
        
        profileClassLabel = UILabel()
        profileClassLabel.text = "Class of 2022" //placeholder
        profileClassLabel.font = UIFont.systemFont(ofSize: 18)
        profileClassLabel.textColor = .white
        view.addSubview(profileClassLabel)
        
        profileCollegeLabel = UILabel()
        profileCollegeLabel.text = "College of Engineering" //placeholder
        profileCollegeLabel.font = UIFont.systemFont(ofSize: 18)
        profileCollegeLabel.textColor = .white
        view.addSubview(profileCollegeLabel)
        
        profileMajorLabel = UILabel()
        profileMajorLabel.text = "Computer Science" //placeholder
        profileMajorLabel.font = UIFont.systemFont(ofSize: 18)
        profileMajorLabel.textColor = .white
        view.addSubview(profileMajorLabel)
        
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
        profileNavigatorView.register(PeopleCollectionViewCell.self, forCellWithReuseIdentifier: peopleViewReuseIdentifier)
        view.addSubview(profileNavigatorView)
        
        // MARK: Background
        view.backgroundColor = .white
        view.applyGradient(with: [UIColor(displayP3Red: 100.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1), UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.3)])
            
        // MARK: Animations
        hero.isEnabled = true
        view.hero.id = "backdrop"
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        
        profileNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(75)
            make.left.equalTo(view).offset(25)
            make.width.equalTo(375)
            make.height.equalTo(24)
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(profileNameLabel).offset(50)
            make.left.equalTo(view).offset(25)
            make.height.width.equalTo(100)
        }
        
        profileClassLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImage)
            make.left.equalTo(profileNameLabel).offset(120)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        profileCollegeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileClassLabel).offset(40)
            make.left.equalTo(profileClassLabel)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        profileMajorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileCollegeLabel).offset(40)
            make.left.equalTo(profileCollegeLabel)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        profileNavigator.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(profileMajorLabel).offset(50)
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
