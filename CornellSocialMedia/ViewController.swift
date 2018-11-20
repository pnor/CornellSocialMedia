//
//  ViewController.swift
//  CornellSocialMedia
//
//  Created by Phillip OReggio on 11/19/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var hello : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hello = UILabel()
        hello.text = "Hello World"
        view.addSubview(hello)
        
        view.backgroundColor = .white
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        hello.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
        }
    }


}

