//
//  AlbumView.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 15/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import UIKit

class AlbumView: UIView {
    var coverImage: UIImageView
    var indicator: UIActivityIndicatorView
    
    init(frame: CGRect, albumCover: String) {
        self.coverImage = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        self.indicator = UIActivityIndicatorView()
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        self.addSubview(self.coverImage)
        
        self.indicator.center = self.center
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.indicator.startAnimating()
        self.addSubview(self.indicator)
        
        self.coverImage.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.allZeros, context: nil)
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "BLDownloadImageNotification", object: self, userInfo: ["imageView": coverImage, "coverUrl": albumCover]))
    }
    
    deinit {
        self.coverImage.removeObserver(self, forKeyPath: "image")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "image" && self.coverImage.image != nil {
            self.indicator.stopAnimating()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}