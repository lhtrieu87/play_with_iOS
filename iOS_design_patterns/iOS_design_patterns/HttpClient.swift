//
//  HttpClient.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 16/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import Foundation
import UIKit

class HttpClient: NSObject {
    func postRequest(url: String, data: [String: AnyObject?]) {
        
    }
    
    func deleteRequest(url: String, data: [String: AnyObject?]) {
        
    }
    
    func downloadImage(url: String) -> UIImage? {
        if let data: NSData = NSData(contentsOfURL: NSURL(string: url)!) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        
        return nil
    }
}
