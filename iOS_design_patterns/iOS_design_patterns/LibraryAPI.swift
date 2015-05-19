//
//  LibraryAPI.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 16/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import Foundation
import UIKit

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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "downloadImage:", name: "BLDownloadImageNotification", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func downloadImage(notification: NSNotification) {
        let imageView = notification.userInfo!["imageView"] as! UIImageView
        let coverUrl = notification.userInfo!["coverUrl"] as! String
        
        imageView.image = persistencyManager.getImage(coverUrl.lastPathComponent)
        
        if imageView.image == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let image: UIImage = self.httpClient.downloadImage(coverUrl) {
                    dispatch_sync(dispatch_get_main_queue(), {
                        imageView.image = image
                        self.persistencyManager.saveImage(image, fileName: coverUrl.lastPathComponent)
                    })
                }
            })
        }
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
