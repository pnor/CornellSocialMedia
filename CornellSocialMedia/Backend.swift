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
    
    private static let gLoginEndpoint = "35.245.236.152/glogin/"
    
//    static func getGLogin(_ didGetGLogin: @escaping ([Recipe]) -> Void) {
//        Alamofire.request(recipePuppyURL, method: .get, parameters: parameters).validate().responseData { (response) in
//            switch response.result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//                if let recipes = try? decoder.decode(RecipeSearchResponse.self, from: data){
//                    didGetRecipes(recipes.results)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
}
