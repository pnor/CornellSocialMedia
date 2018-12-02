//
//  Debugging.swift
//  CornellSocialMedia
//
//  Created by Phillip OReggio on 11/26/18.
//  Copyright © 2018 CS1998FinalPGAV. All rights reserved.
//

import UIKit

// For various Debugging Purposes and providing Default Values
class Debugging {
    // MARK: - Settings
    static let onlyShowNormalPosts = false
    
    // MARK: - Getting Posts
    static func getDefaultPosts() -> [Post] {
        let shortPost = Post(name: "Tommy", profileImage: UIImage(named: "cornellC")!, body: "Watup Gang")
        let mediumPost = Post(name: "Thomas", profileImage: UIImage(named: "cornellC")!, body:
            " What is up my fellow classmates. My name is thomas and I am simply overjoyed to be a member of the Cornell '22 graduating class. My favorite color is combination on orange and magenta, and I really enjoy multivariant calcalus. I hope to share my love on this fine app.")
        let longLargePost = Post(name: "Tommy Barthelemou II - Duke of England", profileImage: UIImage(named: "cornellC")!, body: "8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888")
        let imagePost = Post(name: "Image Kid", profileImage: UIImage(named: "cornell2")!, image: UIImage(named: "cornell2"))
        let imagePostWithCaption = Post(name: "Image Kid that Speaks", profileImage: UIImage(named: "cornellC")!, body: "Hi guys check out my cool picture; cool right?", image: UIImage(named: "cornell2")!)
        let blankPost = Post(name: "hacker", profileImage: UIImage(named: "cornellC")!)
        
        return [
            shortPost, shortPost.copy(), shortPost.copy(),
            mediumPost, mediumPost.copy(), mediumPost.copy(),
            longLargePost, longLargePost.copy(), longLargePost.copy(),
            imagePost, imagePost.copy(), imagePost.copy(),
            imagePostWithCaption, imagePostWithCaption.copy(), imagePostWithCaption.copy(),
            blankPost, blankPost.copy(), blankPost.copy()
        ]
//        return [
//            shortPost, mediumPost, longLargePost, imagePost, imagePostWithCaption, blankPost,
//            mediumPost.copy(), imagePost.copy(), longLargePost.copy(), imagePostWithCaption.copy(),
//            blankPost.copy(), shortPost.copy(), shortPost.copy(), longLargePost.copy(),
//            imagePostWithCaption.copy(), imagePost.copy()
//        ]
    }
    
    /// returns a random post
    static func randomPost() -> Post {
        return getPostType(randomPostType)
    }
    
    /// randomly selects one of the provided types
    static func getPostType(_ types: [PostType]) -> Post {
        return getPostType(types.randomElement()!)
    }
    
    /// gets a post of the provided type
    static func getPostType(_ type: PostType) -> Post {
        switch (type) {
        case .short:
            return Post(name: randomWord, profileImage: getRandomImage(), body: randomSentence(word: (3...12).randomElement()!))
        case.medium:
            return Post(name: randomWord, profileImage: getRandomImage(), body: randomSentence(word: (20...60).randomElement()!))
        case .long:
            return Post(name: randomWord, profileImage: getRandomImage(), body: randomSentence(word: (80...120).randomElement()!))
        case .image:
            return Post(name: randomWord, profileImage: getRandomImage(), body: randomSentence(word: (2...20).randomElement()!), image: getRandomImage())
            return Post(name: randomWord, profileImage: getRandomImage(), image: getRandomImage())
        case .imageCaptionless:
            return Post(name: randomWord, profileImage: getRandomImage(), image: getRandomImage())
        case .noBody:
            return Post(name: randomWord, profileImage: getRandomImage())
        }
    }
    
    
    //MARK: Random Text Generation
    private static var randomWord : String {
        get {
            let availableWords = [
                "Lorem",
                "Ipsum",
                "Dolor",
                "Sit",
                "Amet",
                "Vu",
                "Vitae",
                "Oportaet",
                "Occuret",
                "Eam",
                "Alli"
            ]
            return availableWords.randomElement()!
        }
    }
    
    private static func randomSentence(word: Int) -> String {
        var str = ""
        for _ in 1...word {
            str.append(randomWord + " ")
        }
        return str
    }
    
    // MARK: Random Image
    private static func getRandomImage() -> UIImage{
        let possibleImages = [
            "cornellC",
            "cornell1",
            "cornell2",
            "cornell3",
            "cornell4",
            "cornell5",
            "cornell6",
            "cornell7",
            "cornell8",
        ]
        return UIImage(named: possibleImages.randomElement()!)!
    }
    
    // MARK: Random Post Type
    private static var randomPostType : PostType {
        get {
            return PostType(rawValue: onlyShowNormalPosts ?
                (1...5).randomElement() ?? 1 :
                (1...6).randomElement() ?? 1)!
        }
    }
    
    enum PostType : Int {
        // Normal Posts
        case short = 1 // A short text post
        case medium = 2 // A medium text post
        case long = 3 // A long text post
        case image = 4 // An Image Post with a caption
        case imageCaptionless = 5 // An Image Post without a caption
        // Wierd stuff
        case noBody = 6 // A Text post with no text (or image)
    }
}

extension Post {
    func copy() -> Post {
        return Post(name: self.name, profileImage: self.profileImage, body: self.text, image: self.image)
    }
}
