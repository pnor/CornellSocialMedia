//
//  Post.swift
//  CornellSocialMedia
//
// Dummy Class representing a Post. Will likely not change a lot once we see what data we have. Used mainly so the CollectionViewCells on the Main Feed have something to display
//
//  Created by Phillip OReggio on 11/23/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

class Post : CustomStringConvertible {
    let name : String!
    let profileImage : UIImage!
    let text : String? // may not have written a text caption
    let image : UIImage? // may not of posted an image
    
    init(name: String, profileImage: UIImage, body: String? = nil, image: UIImage? = nil) {
        self.name = name
        self.profileImage = profileImage
        self.text = body
        self.image = image
    }
    
    var description: String {
        return "Post<name? \(name)||text: \(text != nil)|image: \(image != nil)>\n"
        //return "Post<Name: \(name)|profileImage: \(profileImage)|text: \(text)|image: \(image)>"
    }
}
