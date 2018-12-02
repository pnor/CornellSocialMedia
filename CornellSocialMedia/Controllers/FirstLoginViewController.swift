//
//  FirstLoginViewController.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 12/2/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class FirstLoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //Text
    var nameLabel: UILabel!
    var instructionsTextView: UITextView!
    
    //Image
    var profileImageButton: UIButton!
    
    //Picker Views
    var classPicker: UIPickerView!
    var collegePicker: UIPickerView!
    var majorPicker: UIPickerView!
    
    //Picker View DataSources
    var classPickerDataSource: [String] = ["2019", "2020", "2021", "2022"]
    var collegePickerDataSource: [String] = ["College of Agriculture and Life Sciences", "College of Architecture, Art and Planning", "College of Arts and Sciences", "Cornell SC Johnson College of Business", "College of Engineering", "College of Human Ecology", "School of Industrial and Labor Relations (ILR)"]
    var majorPickerDataSource: [String] = ["Undecided", "Africana Studies", "Agricultural Sciences", "American Studies", "Animal Science", "Anthropology", "Applied Economics and Management", "Archaeology", "Architecture", "Asian Studies", "Astronomy", "Atmospheric Science", "Biological Engineering", "Biological Sciences", "Biology and Society", "Biomedical Engineering", "Biometry and Statistics", "Chemical Engineering", "Chemistry and Chemical Biology", "China and Asia-Pacific Studies", "Civil Engineering", "Classics (Classics, Classical Civ., Greek, Latin)", "College Scholar Program", "Communication", "Comparative Literature", "Computer Science", "Design and Environmental Analysis", "Development Sociology", "Earth and Atmospheric Sciences", "Economics", "Electrical and Computer Engineering", "Engineering Physics", "English", "Entomology", "Environmental and Sustainability Sciences", "Environmental Engineering", "Feminist, Gender & Sexuality Studies", "Fiber Science and Apparel Design", "Fine Arts", "Food Science", "French", "German Studies", "Global & Public Health Sciences", "Government", "History", "History of Architecture", "History of Art", "Hotel Administration", "Human Biology, Health and Society", "Human Development", "Independent Major - Arts and Sciences", "Independent Major - Engineering", "Industrial and Labor Relations", "Information Science", "Information Science, Systems, and Technology", "Interdisciplinary Studies", "International Agriculture and Rural Development", "Italian", "Landscape Architecture", "Linguistics", "Materials Science and Engineering", "Mathematics", "Mechnical Engineering", "Music", "Near Eastern Studies", "Nutritional Sciences", "Operations Research and Engineering", "Performing and Media Arts", "Philosophy", "Physics", "Plant Sciences", "Policy Analysis and Management", "Psychology", "Religious Studies", "Science and Technology Studies", "Sociology", "Spanish", "Statistical Science", "Urban and Regional Studies", "Viticulture and Enology"]
    
    //Profile Values
    var name = "Gonzalo Gonzalez-Pumariega" //placeholder
    var classOf: String
    var college: String
    var major: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - UI Elements
        nameLabel = UILabel()
        nameLabel.text = "Welcome, " + name.split(separator: " ")[0]
        
        
        instructionsTextView = UITextView()
        instructionsTextView.isScrollEnabled = false
        
        profileImageButton = UIButton()
        
        classPicker = UIPickerView()
        
        collegePicker = UIPickerView()
        
        majorPicker = UIPickerView()
        
        //Background
        view.backgroundColor = .white
        
        setupConstraints()
    }
    
    func setupConstraints(){
        
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == classPicker{
            return classPickerDataSource[row]
        } else if pickerView == collegePicker{
            return collegePickerDataSource[row]
        } else{
            return majorPickerDataSource[row]
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

}
