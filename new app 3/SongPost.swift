//
//  SongPost.swift
//  new app 3
//
//  Created by William Hinson on 3/7/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation

class SongPost {
    var id: String
    var author: User
    var title: String
    var coverImage: URL
    var audioUrl: [URL]
    var audioName : [String]
    var createdAt:Date
    var likes: Int
    var didLike = false
    var streams: Int
    
    
    
    
    init(id:String, author:User, title:String, coverImage:URL, audioUrl:[URL], audioName: [String], likes:Int ,timestamp:Double, streams: Int) {
        self.id = id
        self.author = author
        self.coverImage = coverImage
        self.audioUrl = audioUrl
        self.audioName = audioName
        self.likes = likes
        self.title = title
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
        self.streams = streams
    }
    
    
}
