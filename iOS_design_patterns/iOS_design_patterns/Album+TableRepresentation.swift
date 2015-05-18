//
//  Album+TableRepresentation.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 18/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import Foundation

extension Album {
    func tr_tableRepresentation() -> [String: [String]] {
        return ["titles": ["Artist", "Album", "Genre", "Year"],
            "values": [self.artist, self.title, self.genre, self.year]]
    }
}