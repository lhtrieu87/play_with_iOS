//
//  PersistencyManager.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 16/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import Foundation

class PersistencyManager: NSObject {
    private var albums: [Album]
    
    override init() {
        self.albums = [
            Album(title: "Best of Bowie", artist:"David Bowie", genre: "Pop", coverUrl:"http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png", year:"1992"),
            Album(title: "It's My Life", artist:"No Doubt", genre: "Pop", coverUrl:"http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png", year:"2003"),
            Album(title: "Nothing Like The Sun", artist:"Sting", genre: "Pop", coverUrl:"http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png", year:"1999"),
            Album(title: "Staring at the Sun", artist:"U2", genre: "Pop", coverUrl:"http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png", year:"2000"),
            Album(title: "American Pie", artist:"Madonna", genre: "Pop", coverUrl:"http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png", year:"2000")
        ]
        
        super.init()
    }
    
    func getAlbums() -> [Album] {
        return albums
    }
    
    func addAlbum(album: Album, index: Int) {
        if index >= self.albums.count {
            self.albums.append(album)
        } else if index >= 0 {
            self.albums.insert(album, atIndex: index)
        }
    }
    
    func deleteAlbum(index: Int) {
        if index >= 0 && index < self.albums.count {
            self.albums.removeAtIndex(index)
        }
    }
}
