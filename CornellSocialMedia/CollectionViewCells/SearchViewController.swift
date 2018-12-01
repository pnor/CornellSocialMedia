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
    var filterButton: UIBarButtonItem!
    var rightBackButton: UIBarButtonItem!
    
    // Collection View Elements
    let peopleReuseIdentifier = "peopleReuseIdentifier"
    
    //MARK: - People Information
    var people: [People] = []
    
    let person1 = People(name: "Gonzalo Gonzalez", photo: UIImage(named: "cornell1")!, classOf: 2022, college: "College of Engineering", major: "Computer Science")
    let person2 = People(name: "Phillip O' Reggio", photo: UIImage(named: "cornell2")!, classOf: 2023, college: "College of Engineering", major: "iOS")
    let person3 = People(name: "Alisa Lai", photo: UIImage(named: "cornell1")!, classOf: 3022, college: "College of Engineering", major: "Backend")
    let person4 = People(name: "Vivian Cheng", photo: UIImage(named: "cornell2")!, classOf: 3023, college: "College of Engineering", major: "Design")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        people = [person1, person2, person3, person4, person3, person1, person4, person2, person3, person1, person4, person2]
        
        //people = [person1, person2]
        
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
        //peopleLayout.minimumInteritemSpacing = 32
        peopleLayout.minimumLineSpacing = 8
        peopleLayout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        peopleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: peopleLayout)
        peopleCollectionView.backgroundColor = view.backgroundColor
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self
        peopleCollectionView.alwaysBounceVertical = true
        peopleCollectionView.register(PeopleCollectionViewCell.self, forCellWithReuseIdentifier: peopleReuseIdentifier)
        view.addSubview(peopleCollectionView)
        
        filterButton = UIBarButtonItem()
        filterButton.title = "Filter"
        filterButton.target = self
        filterButton.tintColor = .white
        filterButton.action = #selector(presentPeopleFilterViewController)
        navigationItem.leftBarButtonItem = filterButton
        
        rightBackButton = UIBarButtonItem()
        rightBackButton.title = "Back>"
        rightBackButton.target = self
        rightBackButton.tintColor = .white
        rightBackButton.action = #selector(goBack)
        navigationItem.rightBarButtonItem = rightBackButton
        navigationItem.hidesBackButton = true
        
        //MARK: Background
        view.backgroundColor = .white
        
        // MARK: Animations
        hero.isEnabled = true
        view.hero.id = "backdrop"
        view.applyGradient(with: [
            .gray,
            UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.6)],
                           gradient: .topLeftBottomRight)
        peopleCollectionView.hero.modifiers = [.translate(x:-100)]

        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        peopleCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(view)
        }
    }
    
    //MARK: - Modal Controller Presenters
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func presentPeopleFilterViewController(){
        let peopleFilter = PeopleFilterViewController()
        //peopleFilter.peopleFilterDelegate = self
        //filters chosen should go in an array of filters that then filters the people in a database accordingly
        //filters should save while still in search but clears when you go back to message board~
        present(peopleFilter, animated: true, completion: nil)
    }

    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: peopleReuseIdentifier, for: indexPath) as! PeopleCollectionViewCell
        let person = people[indexPath.item]
        cell.configure(with: person)
        cell.setNeedsUpdateConstraints()
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 25
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = peopleCollectionView.frame.width
        return CGSize(width: width-25, height: 175)
    }
    
    //MARK: - Search Controller
    func updateSearchResults(for searchController: UISearchController) {
        //TODO after filters page
    }
}
