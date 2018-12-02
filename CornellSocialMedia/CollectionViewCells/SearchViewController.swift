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
    var peoplePlaceHolder: [People] = []
    
    let person1 = People(name: "Gonzalo Gonzalez", photo: UIImage(named: "cornell1")!, classOf: 2022, college: "College of Engineering", major: "Computer Science")
    let person2 = People(name: "Phillip O' Reggio", photo: UIImage(named: "cornell2")!, classOf: 2023, college: "College of Engineering", major: "iOS")
    let person3 = People(name: "Alisa Lai", photo: UIImage(named: "cornell1")!, classOf: 3022, college: "College of Engineering", major: "Backend")
    let person4 = People(name: "Vivian Cheng", photo: UIImage(named: "cornell2")!, classOf: 3023, college: "College of Engineering", major: "Design")
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 27/255, blue: 27/255, alpha: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let navigationBar = navigationController?.navigationBar
        navigationBar!.barTintColor = .white
        navigationBar!.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        peoplePlaceHolder = [person1, person2, person3, person4]
        
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
        
        //MARK: Background
        view.backgroundColor = .gray
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        peopleCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(view)
        }
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
        if let searchText = searchPeopleController.searchBar.text {
            if !searchText.isEmpty {
                for person in peoplePlaceHolder{
                    let hasPerson = people.contains { (peoplePerson) -> Bool in
                        if person.name == peoplePerson.name{
                            return true
                        }
                        return false
                    }
                    if (hasPerson){
                        if person.name.lowercased().range(of: searchText.lowercased()) == nil{
                            people = people.filter({ (peoplePerson) -> Bool in
                                return person.name != peoplePerson.name
                            })
                        }
                    } else {
                        if person.name.lowercased().range(of: searchText.lowercased()) != nil{
                            people.append(person)
                        }
                    }
                }
                peopleCollectionView.reloadData()
            } else {
                self.people = []
                peopleCollectionView.reloadData()
            }
        }
    }

}
