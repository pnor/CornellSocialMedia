//
//  ViewController.swift
//  CornellSocialMedia
//
//  Created by Phillip OReggio on 11/19/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit
import SnapKit
import TextFieldEffects

class LoginViewController: UIViewController {
    
    // MARK: - Parameters
    // UI Elements
    var backgroundImage : UIImageView!
    var loginTitle : UILabel!
    var username : IsaoTextField!
    var password : IsaoTextField!
    var login : UIButton!
    
    // Log In Error Message
    var alert : UIAlertController!
    
    // Padding
    let titlePadding = 130
    let padding = 60
    let textFieldWidth = 180
    let buttonWidth = 140
    let buttonHeight = 30
    
    /// Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - UI Elements
        backgroundImage = UIImageView(image: getABackgroundImage())
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.alpha = 0.35
        view.addSubview(backgroundImage)

        loginTitle = UILabel()
        loginTitle.text = "Welcome"
        loginTitle.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        loginTitle.textColor = .white
        loginTitle.alpha = 0
        view.addSubview(loginTitle)
        
        username = IsaoTextField()
        username.placeholder = "Username"
        username.textColor = .white
        username.activeColor = .red
        username.inactiveColor = .white
        username.font = UIFont.systemFont(ofSize: 20)
        username.alpha = 0.1
        view.addSubview(username)
        
        password = IsaoTextField()
        password.placeholder = "Password"
        password.textColor = .white
        password.activeColor = .red
        password.inactiveColor = .white
        password.font = UIFont.systemFont(ofSize: 20)
        password.isSecureTextEntry = true
        password.alpha = 0.2
        view.addSubview(password)
        
        login = UIButton()
        login.setTitle("Log in", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.bounds = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        login.clipsToBounds = true
        login.applyGradient(with: [.red, UIColor(hue: 0.1, saturation: 1, brightness: 1, alpha: 1)], gradient: .topLeftBottomRight)
        login.layer.cornerRadius = 10
        login.alpha = 0.3
        login.addTarget(self, action: #selector(loginPressed), for: .touchDown)
        view.addSubview(login)
        
        // MARK: Background
        view.backgroundColor = .darkGray
        navigationController?.isNavigationBarHidden = true
        
        // MARK: Error Prompt
        alert = UIAlertController(title: "Error", message: "Could not log in with provided information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            self.alert.dismiss(animated: true, completion: nil)
        }))
        
        // MARK: Animations
        UIView.animate(withDuration: 1) {
            self.loginTitle.alpha = 1
            self.username.alpha = 1
            self.password.alpha = 1
            self.login.alpha = 1
        }
        
        setNeedsStatusBarAppearanceUpdate()
        setUpConstraints()
    }
    
    // MARK: - Button and Error Prompt
    @objc func loginPressed() {
        // TODO: implement proper login
        // validate username + passqord
        // if all good go to main screen:
        present(alert, animated: true, completion: nil)
        print("login button pressed")
    }
    
    
    // MARK: - Functions for UI and Positioning
    /**
     Gets a random image from the assets name "cornell#" where # is an integer
     */
    func getABackgroundImage() -> UIImage {
        let cornellImages = (1...2)
        let randomInt = cornellImages.randomElement() ?? 1
        if let image = UIImage(named: "cornell\(randomInt)") { // all is well
            return image
        } else { // asset doesn't exist
            fatalError("Tried to display a background image at \(randomInt); does cornell\(randomInt) exist in assets?")
        }
    }
    
    func setUpConstraints() {
        backgroundImage.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        loginTitle.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-titlePadding)
        }
        
        username.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(view).offset(padding)
            make.centerX.equalTo(view)
            make.width.equalTo(textFieldWidth)
        }
        
        password.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(username.snp_bottomMargin).offset(padding)
            make.centerX.equalTo(view)
            make.width.equalTo(textFieldWidth)
        }
        
        login.snp.makeConstraints { (make)  -> Void in
            make.top.equalTo(password.snp_bottomMargin).offset(padding)
            make.centerX.equalTo(view)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
    }
}

