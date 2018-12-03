//
//  PostViewController.swift
//  CornellSocialMedia
//
//  Created by Phillip OReggio on 12/2/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Parameters
    var titleLabel : UILabel!
    var textEntry : UITextView!
    var pictureEntry : UIImageView!
    var postButton : UIButton!
    var postImageButton : UIButton!
    
    // spacing
    let padding = 20
    let imageHeight = 160
    let imageWidth = 180
    
    // settings
    var allowsImagePosting = true
    /// true if its a normal post. false if its a post going to the comments
    var fromComments = false
    
    //Photo Elements
    var imagePicker: UIImagePickerController!
    var imageAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // UI Elements
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = "Post"
        view.addSubview(titleLabel)
        
        textEntry = UITextView()
        textEntry.textColor = .black
        textEntry.text = "Type Something..."
        textEntry.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textEntry.allowsEditingTextAttributes = true
        textEntry.backgroundColor = .clear
        textEntry.sizeToFit()
        textEntry.isScrollEnabled = true
        view.addSubview(textEntry)
        
        postButton = UIButton()
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.layer.cornerRadius = 5
        postButton.layer.masksToBounds = true
        postButton.backgroundColor = .red
        postButton.addTarget(self, action: #selector(post), for: .touchDown)
        view.addSubview(postButton)
        
        postImageButton = UIButton()
        postImageButton.setImage(UIImage(named: "camera"), for: .normal)
        postImageButton.tintColor = .red
        postImageButton.addTarget(self, action: #selector(imageButtonPressed), for: .touchDown)
        if allowsImagePosting {
            view.addSubview(postImageButton)
        }
        
        // Images
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imageAlert = UIAlertController(
            title: "Choose Option",
            message: "Choose to take a photo or select one from your library",
            preferredStyle: .alert)
        imageAlert.addAction(
            UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                self.presentChoice();
        }))
        imageAlert.addAction(UIAlertAction(
            title: "Library", style: .default, handler: { (alert) in
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            self.presentChoice();
        }))
        
        // Background
        view.hero.isEnabled = true
        view.applyGradient(with: [.white, UIColor(hue: 1, saturation: 0.2, brightness: 1, alpha: 1)], gradient: .topLeftBottomRight)
        
        // Animations
        view.hero.id = "backdrop"
        postButton.hero.modifiers = [.fade]
        textEntry.hero.modifiers = [.fade]
        
        setupConstraints(withImage: false)
    }
    
    /// with Image means the view will have an image on the bottom (if the user posts an image)
    func setupConstraints(withImage: Bool) {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(padding)
        }
        
        textEntry.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
        }
        
        
        if allowsImagePosting {
            postButton.snp.makeConstraints { (make) in
                make.leading.equalTo(textEntry).inset(padding * 2)
                make.width.equalTo(140)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(padding * 2)
            }
            postImageButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview().inset(padding * 4)
                make.size.equalTo(20)
                make.centerY.equalTo(postButton)
            }
        } else {
            postButton.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(140)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(padding * 2)
            }
        }
        print(withImage)
        if withImage {
            pictureEntry.snp.makeConstraints { (make) in
                make.bottom.equalTo(postButton.snp.top).inset(padding)
                make.height.equalTo(imageHeight)
                make.width.equalTo(imageWidth)
                make.centerX.equalToSuperview()
            }
            textEntry.snp.makeConstraints { (make) in
                make.bottom.equalTo(pictureEntry).inset(padding * 2)
            }
            
        } else {
            textEntry.snp.makeConstraints { (make) in
                make.bottom.equalTo(postButton.snp.top).inset(padding * 2)
            }
        }
    }
    
    // MARK: - UI Element Actions
    @objc func post() {
        print(" < Posting >")
        //_ = Post(name: "user", profileImage: UIImage(), body: textEntry.text, image: pictureEntry.image)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func imageButtonPressed() {
        // Change to Image Mode
        view.snp.removeConstraints()
        
        pictureEntry = UIImageView()
        pictureEntry.layer.cornerRadius = 20
        pictureEntry.layer.masksToBounds = true
        pictureEntry.contentMode = .scaleAspectFit
        view.addSubview(pictureEntry)
        
        setupConstraints(withImage: true)
        //view.setNeedsUpdateConstraints()
        
        choosePhotoMode()
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
        pictureEntry.image = imagePicked
        dismiss(animated: true, completion: nil)
    }
}
