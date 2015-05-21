//
//  Command.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 21/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import Foundation

class Command {
    let function: ([AnyObject?] -> AnyObject?)?
    let target: AnyObject?
    let arguments: [AnyObject?]?
    
    init(target: AnyObject?, f: [AnyObject?] -> AnyObject?, args: [AnyObject?]?) {
        self.function = f
        self.target = target
        self.arguments = args
    }
    
    func execute(otherArgs: [AnyObject?]?) -> AnyObject? {
        var finalArgs = [self.target]
        if let args = self.arguments {
            finalArgs += args
        }
        
        if let args = otherArgs {
            finalArgs += args
        }
        
        return self.function?(finalArgs)
    }
}
