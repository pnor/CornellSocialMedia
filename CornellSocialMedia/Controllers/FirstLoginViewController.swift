//
//  FirstLoginViewController.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 12/2/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class FirstLoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Text
    var instructionsTextView: UITextView!
    var nameTextField: UITextField!
    
    //Image
    var profileImageButton: UIButton!
    var imagePicker: UIImagePickerController!
    var imageAlert: UIAlertController!
    
    //Picker Views
    var classPicker: UIPickerView!
    var collegePicker: UIPickerView!
    var majorPicker: UIPickerView!
    
    //Picker View DataSources
    var classPickerDataSource: [String] = ["Class Year","2019", "2020", "2021", "2022"]
    var collegePickerDataSource: [String] = ["College", "College of Agriculture and Life Sciences", "College of Architecture, Art and Planning", "College of Arts and Sciences", "Cornell SC Johnson College of Business", "College of Engineering", "College of Human Ecology", "School of Industrial and Labor Relations (ILR)"]
    var majorPickerDataSource: [String] = ["Major", "Undecided", "Africana Studies", "Agricultural Sciences", "American Studies", "Animal Science", "Anthropology", "Applied Economics and Management", "Archaeology", "Architecture", "Asian Studies", "Astronomy", "Atmospheric Science", "Biological Engineering", "Biological Sciences", "Biology and Society", "Biomedical Engineering", "Biometry and Statistics", "Chemical Engineering", "Chemistry and Chemical Biology", "China and Asia-Pacific Studies", "Civil Engineering", "Classics (Classics, Classical Civ., Greek, Latin)", "College Scholar Program", "Communication", "Comparative Literature", "Computer Science", "Design and Environmental Analysis", "Development Sociology", "Earth and Atmospheric Sciences", "Economics", "Electrical and Computer Engineering", "Engineering Physics", "English", "Entomology", "Environmental and Sustainability Sciences", "Environmental Engineering", "Feminist, Gender & Sexuality Studies", "Fiber Science and Apparel Design", "Fine Arts", "Food Science", "French", "German Studies", "Global & Public Health Sciences", "Government", "History", "History of Architecture", "History of Art", "Hotel Administration", "Human Biology, Health and Society", "Human Development", "Independent Major - Arts and Sciences", "Independent Major - Engineering", "Industrial and Labor Relations", "Information Science", "Information Science, Systems, and Technology", "Interdisciplinary Studies", "International Agriculture and Rural Development", "Italian", "Landscape Architecture", "Linguistics", "Materials Science and Engineering", "Mathematics", "Mechnical Engineering", "Music", "Near Eastern Studies", "Nutritional Sciences", "Operations Research and Engineering", "Performing and Media Arts", "Philosophy", "Physics", "Plant Sciences", "Policy Analysis and Management", "Psychology", "Religious Studies", "Science and Technology Studies", "Sociology", "Spanish", "Statistical Science", "Urban and Regional Studies", "Viticulture and Enology"]
    
    //Profile Values
    var name = ""
    var classOf: String = "Class Year"
    var college: String = "College"
    var major: String = "Major"
    
    //Continue Logistics
    var continueButton: UIButton!
    var fillAllFieldsAlert: UIAlertController!
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.pushViewController(MainFeedViewController(), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true) //remove after bc its presentedc
        //MARK: - UI Elements
        nameTextField = UITextField()
        nameTextField.placeholder = "Enter your name"
        nameTextField.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(nameTextField)
        
        instructionsTextView = UITextView()
        instructionsTextView.isScrollEnabled = false
        instructionsTextView.isEditable = false
        instructionsTextView.text = "Fill out all fields to create your account"
        instructionsTextView.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(instructionsTextView)
        
        profileImageButton = UIButton()
        profileImageButton.setImage(UIImage(named: "cornellC"), for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        profileImageButton.layer.cornerRadius = 50
        profileImageButton.clipsToBounds = true
        profileImageButton.addTarget(self, action: #selector(choosePhotoMode), for: .touchUpInside)
        view.addSubview(profileImageButton)
        
        classPicker = UIPickerView()
        classPicker.dataSource = self
        classPicker.delegate = self
        view.addSubview(classPicker)
        
        collegePicker = UIPickerView()
        collegePicker.dataSource = self
        collegePicker.delegate = self
        view.addSubview(collegePicker)
        
        majorPicker = UIPickerView()
        majorPicker.dataSource = self
        majorPicker.delegate = self
        view.addSubview(majorPicker)
        
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
        
        continueButton = UIButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.red, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        continueButton.addTarget(self, action: #selector(checkIfCanContinue), for: .touchUpInside)
        view.addSubview(continueButton)
        
        fillAllFieldsAlert = UIAlertController(title: "Missing Information",
                                               message: "Please fill out all fields before continuing",
                                               preferredStyle: .alert)
        fillAllFieldsAlert.addAction(UIAlertAction(title: "Got it",
                                                   style: .default,
                                                   handler: nil))
        
        //Background
        view.backgroundColor = .white
        
        setupConstraints()
    }
    
    func setupConstraints(){
        
        instructionsTextView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(25)
            make.height.equalTo(35)
            make.centerX.equalTo(view)
        }
        
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(instructionsTextView).offset(40)
            make.height.equalTo(20)
            make.centerX.equalTo(view)
        }
        
        profileImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField).offset(40)
            make.width.height.equalTo(100)
            make.centerX.equalTo(view)
        }
        
        classPicker.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageButton).offset(100)
            make.height.equalTo(100)
            make.centerX.equalTo(view)
        }
        
        collegePicker.snp.makeConstraints { (make) in
            make.top.equalTo(classPicker).offset(100)
            make.height.equalTo(100)
            make.centerX.equalTo(view)
        }
        
        majorPicker.snp.makeConstraints { (make) in
            make.top.equalTo(collegePicker).offset(125)
            make.height.equalTo(150)
            make.centerX.equalTo(view)
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-30)
            make.height.equalTo(30)
            make.centerX.equalTo(view)
        }
        
    }
    
    //MARK: - Picker View Protocol Stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == classPicker{
            return classPickerDataSource.count
        } else if pickerView == collegePicker{
            return collegePickerDataSource.count
        } else{
            return majorPickerDataSource.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == classPicker{
            classOf = classPickerDataSource[row]
        } else if pickerView == collegePicker{
            college = collegePickerDataSource[row]
        } else{
            major = majorPickerDataSource[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 14)
            pickerLabel?.textAlignment = .center
        }
        
        if pickerView == classPicker{
            pickerLabel?.text = classPickerDataSource[row]
        } else if pickerView == collegePicker{
            pickerLabel?.text = collegePickerDataSource[row]
        } else{
            pickerLabel?.text = majorPickerDataSource[row]
        }
        
        return pickerLabel!
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
        profileImageButton.setImage(imagePicked, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Button Functions
    @objc func checkIfCanContinue(){
        name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (classOf == "Class Year" || college == "College" || major == "Major" || name == ""){
            present(fillAllFieldsAlert, animated: true, completion: nil)
        } else {
            Backend.createProfile(display_name: name, classOf: classOf, image: profileImageButton.image(for: .normal)!, college: college, major: major)
        dismiss(animated: true, completion: nil)
        }
    }

}
