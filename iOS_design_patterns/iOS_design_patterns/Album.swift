//
//  Album.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 15/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import Foundation

@objc class Album: NSObject, NSCoding {
    let title: String, artist: String, genre: String, coverUrl: String, year: String

    init(title: String, artist: String, genre: String, coverUrl: String, year: String) {
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
    }
    
    required init(coder aDecoder: NSCoder) {
        self.year = aDecoder.decodeObjectForKey("year") as! String
        self.genre = aDecoder.decodeObjectForKey("genre") as! String
        self.coverUrl = aDecoder.decodeObjectForKey("coverUrl") as! String
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.artist = aDecoder.decodeObjectForKey("artist") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.year, forKey: "year")
        aCoder.encodeObject(self.genre, forKey: "genre")
        aCoder.encodeObject(self.coverUrl, forKey: "coverUrl")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.artist, forKey: "artist")
    }
}
