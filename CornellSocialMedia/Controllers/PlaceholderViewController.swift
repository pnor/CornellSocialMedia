//
//  PlaceholderViewController.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 12/2/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class PlaceholderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.pushViewController(MainFeedViewController(), animated: true)
        //It's sole purpose is to be dismissed when logged out
        //Thanks for the suggestion Mindy
    }

}
