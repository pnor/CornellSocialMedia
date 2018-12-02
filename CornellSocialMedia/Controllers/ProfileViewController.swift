//
//  ProfileViewController.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 11/25/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    // MARK: - Parameters
    // UI Elements
    var profileNameLabel: UILabel!
    var profileImage: UIButton!
    var profileClassLabel: UILabel!
    var profileCollegeLabel: UILabel!
    var profileMajorLabel: UILabel!
    var profileNavigator: UISegmentedControl!
    var profileNavigatorView: UICollectionView!

    var backButton: UIBarButtonItem!

    //Collection View Elements
    let peopleViewReuseIdentifier = "peopleViewReuseIdentifier"

    //Photo Elements
    var imagePicker: UIImagePickerController!
    var imageAlert: UIAlertController!

    //Profile Functionality Buttons
    var editOrFollowButton: UIButton!
    var logoutBarButton: UIBarButtonItem!

    override func viewWillAppear(_ animated: Bool) {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar!.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar!.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar!.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationBar!.shadowImage = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Title
        title = "Profile"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        // MARK: - UI Elements
        profileNameLabel = UILabel()
        profileNameLabel.text = "Gonzalo Gonzalez-Pumariega" //placeholder
        //should auto-resize font when too big to fit
        //not priority feature
        profileNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        profileNameLabel.textColor = .white
        view.addSubview(profileNameLabel)

        profileImage = UIButton()
        profileImage.setImage(UIImage(named: "cornell2"), for: .normal)
        profileImage.imageView?.contentMode = .scaleAspectFill
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        profileImage.addTarget(self, action: #selector(choosePhotoMode), for: .touchUpInside)
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

        backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.target = self
        backButton.tintColor = .white
        backButton.action = #selector(goBack)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true

        // Swiping
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        // Images
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        imageAlert = UIAlertController(title: "Choose Option",
                                       message: "Choose to take a photo or select one from your library",
                                       preferredStyle: .alert)
        imageAlert.addAction(UIAlertAction(title: "Camera",
                                           style: .default,
                                           handler: { (alert) in
                                            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                                            self.presentChoice();
        }))
        imageAlert.addAction(UIAlertAction(title: "Library",
                                           style: .default,
                                           handler: { (alert) in
                                            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                                            self.presentChoice();
        }))

        editOrFollowButton = UIButton()
        editOrFollowButton.setTitle("Edit Profile", for: .normal) //placeholder; button functionality and title determined whether current logged ID matches the profile ID
        editOrFollowButton.setTitleColor(.white, for: .normal)
        editOrFollowButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        editOrFollowButton.titleLabel?.textAlignment = .center
        editOrFollowButton.backgroundColor = .clear
        editOrFollowButton.layer.cornerRadius = 5
        editOrFollowButton.layer.borderWidth = 1
        editOrFollowButton.layer.borderColor = UIColor.white.cgColor
        view.addSubview(editOrFollowButton)

        logoutBarButton = UIBarButtonItem()
        navigationItem.rightBarButtonItem = logoutBarButton
        logoutBarButton.title = "Logout"
        logoutBarButton.target = self
        logoutBarButton.action = #selector(logout)

        // MARK: Background
        view.backgroundColor = .white
        view.applyGradient(with: [
            UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.3),
            UIColor(displayP3Red: 100.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1)]
            ,gradient: GradientOrientation.topLeftBottomRight)

        // MARK: Animations
        hero.isEnabled = true
        view.hero.id = "backdrop"
        profileImage.hero.modifiers = [.translate(x:100)]
        profileNameLabel.hero.modifiers = [.translate(x:100)]
        profileClassLabel.hero.modifiers = [.translate(x:100)]
        profileMajorLabel.hero.modifiers = [.translate(x:100)]
        profileCollegeLabel.hero.modifiers = [.translate(x:100)]
        profileNavigator.hero.modifiers = [.translate(x:100)]
        editOrFollowButton.hero.modifiers = [.translate(x:100)]

        setUpConstraints()
    }

    func setUpConstraints(){

        profileNameLabel.snp.makeConstraints { (make) in            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.left.equalTo(view).offset(25)
            make.centerX.equalTo(view)
            make.width.equalTo(375)
            make.height.equalTo(24)
        }

        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(profileNameLabel).offset(45)
            make.centerX.equalTo(profileNameLabel)
            make.height.width.equalTo(100)
        }

        profileClassLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImage).offset(100)
            make.centerX.equalTo(profileNameLabel)
            make.height.equalTo(20)
        }

        profileCollegeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileClassLabel).offset(20)
            make.centerX.equalTo(profileNameLabel)
            make.height.equalTo(20)
        }

        profileMajorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileCollegeLabel).offset(20)
            make.centerX.equalTo(profileNameLabel)
            make.height.equalTo(20)
        }

        editOrFollowButton.snp.makeConstraints { (make) in
            make.top.equalTo(profileMajorLabel).offset(25)
            make.centerX.equalTo(view)
            make.width.equalTo(125)
            make.height.equalTo(25)
        }

        profileNavigator.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(editOrFollowButton).offset(40)
            make.height.equalTo(25)
        }

        profileNavigatorView.snp.makeConstraints { (make) in
            make.top.equalTo(profileNavigatorView)
            make.width.bottom.equalTo(view)
        }
    }

    // MARK: Change Views
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Handling Swipes
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                goBack()
            default:
                print("Swiped in a unhandled direction")
            }
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

    //MARK: - Photo Functionability

    @objc func choosePhotoMode(){
        present(imageAlert, animated: true, completion: nil)
    }

    func presentChoice(){
        switch(imagePicker.sourceType){
        case UIImagePickerController.SourceType.camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                present(imagePicker, animated: true, completion: nil)
            }
            break
        case UIImagePickerController.SourceType.photoLibrary:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                present(imagePicker, animated: true, completion: nil)
            }
            break
        default:
            print("Something went wrong with choosePhotoMode")
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImage.setImage(imagePicked, for: .normal)
        dismiss(animated: true, completion: nil)
    }

    //MARK: - Button Functions
    @objc func editProfile(){
        //present a FirstLoginViewController with information already inputted
    }

    @objc func logout(){

    }

}
