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
}
