//
//  People.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 11/25/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import Foundation
import UIKit

struct Peoples: Codable {
    let netid: String
    let display_name: String
    let image: String // url
    let year: Int
    let college: String
    let major: String
    let followers: String //netids delimited by commas
    let following: String
}

//hardcode
class People{
    var name: String!
    var photo: UIImage!
    var classOf: Int!
    var college: String!
    var major: String!

    init(name: String, photo: UIImage, classOf: Int, college: String, major: String){
        self.name = name
        self.photo = photo
        self.classOf = classOf
        self.college = college
        self.major = major
    }
}
