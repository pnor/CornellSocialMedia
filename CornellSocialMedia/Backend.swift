//
//  Backend.swift
//  CornellSocialMedia
//
//  Created by Gonzalo Gonzalez on 12/2/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Backend {
    
    private static let loginEndpoint = "http://35.243.236.152/login/"
    private static let createProfileEndpoint = "http://35.243.236.152/api/profile/user/create/"
    
    static func login(username: String, password: String, completion: @escaping (String) -> Void){
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(loginEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseData { (response) in
            switch response.result{
            case .success(_):
                completion("User exists")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    static func createProfile(display_name: String, classOf: String, image: UIImage, college: String, major: String){
        let parameters: [String: Any] = [
            "display_name": display_name,
            "year": Int(classOf)!,
            "image": image.pngData()!,
            "college": college,
            "major": major
        ]
        
        Alamofire.request(createProfileEndpoint, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseData { (response) in
            switch response.result{
            case .success(_):
                print("success!!!!")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
