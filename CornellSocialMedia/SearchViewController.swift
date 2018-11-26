//
//  SearchViewController.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 11/25/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {

    //MARK: - UI Elements
    var searchPeopleController: UISearchController!
    var peopleCollectionView: UICollectionView!
    
    // Collection View Elements
    let peopleReuseIdentifier = "peopleReuseIdentifier"
    
    //MARK: - People Information
    var people: [People] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - UI Elements
        searchPeopleController = UISearchController(searchResultsController: nil)
        searchPeopleController.searchResultsUpdater = self
        searchPeopleController.dimsBackgroundDuringPresentation = false
        searchPeopleController.searchBar.placeholder = "Find people"
        searchPeopleController.searchBar.sizeToFit()
        definesPresentationContext = true
        navigationItem.searchController = searchPeopleController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let peopleLayout = UICollectionViewFlowLayout()
        peopleLayout.scrollDirection = .vertical
        peopleLayout.minimumInteritemSpacing = 32
        peopleLayout.minimumLineSpacing = 32
        peopleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: peopleLayout)
        peopleCollectionView.backgroundColor = view.backgroundColor
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self
        peopleCollectionView.alwaysBounceVertical = true
        peopleCollectionView.register(PeopleCollectionViewCell.self, forCellWithReuseIdentifier: peopleReuseIdentifier)
        view.addSubview(peopleCollectionView)
        
        //MARK: Background
        view.backgroundColor = .white
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
//        searchPeopleBar.snp.makeConstraints { (make) in
//            make.top.left.equalTo(view).offset(50)
//            make.height.equalTo(100)
//        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: peopleReuseIdentifier, for: indexPath) as! PeopleCollectionViewCell
        let person = people[indexPath.item]
        cell.configure(with: person)
        cell.setNeedsUpdateConstraints()
        //cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }

}
