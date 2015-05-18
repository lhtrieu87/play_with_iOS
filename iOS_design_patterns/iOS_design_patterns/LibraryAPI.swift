//
//  LibraryAPI.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 16/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import Foundation

class LibraryAPI: NSObject {
    static let sharedInstance = LibraryAPI()
    
    private let persistencyManager: PersistencyManager
    private let httpClient: HttpClient
    private let isOnline: Bool
    
    override init() {
        self.persistencyManager = PersistencyManager()
        self.httpClient = HttpClient()
        self.isOnline = false
        
        super.init()
    }
    
    func getAlbums() -> [Album] {
        return self.persistencyManager.getAlbums()
    }
    
    func addAlbum(album: Album, index: Int) {
        self.persistencyManager.addAlbum(album, index: index)
        
        if isOnline {
            httpClient.postRequest("/api/albums", data: [String: AnyObject?]())
        }
    }
    
    func deleteAlbum(index: Int) {
        self.persistencyManager.deleteAlbum(index)
        
        if isOnline {
            self.httpClient.deleteRequest("/api/albums//{index}", data: [String: AnyObject?]())
        }
    }
}
