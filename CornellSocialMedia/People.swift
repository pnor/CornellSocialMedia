//
//  People.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 11/25/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import Foundation

///Eventually for Alisa to fill in
//struct People: Codable {
//
//}

//hardcode
class People{
    var name: String!
    var classOf: Int!
    var college: String!
    var major: String!
    
    init(name: String, classOf: Int, college: String, major: String){
        self.name = name
        self.classOf = classOf
        self.college = college
        self.major = major
    }
}
