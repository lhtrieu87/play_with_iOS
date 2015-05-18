//
//  ViewController.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 15/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var table: UITableView?
    private var allAlbums: [Album] = [Album]()
    private var currentAlbum: [String: [String]]?
    private var currentAlbumIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.81, blue: 0.87, alpha: 1)
        
        self.allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        self.table = UITableView(frame: CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height - 120), style: UITableViewStyle.Grouped)
        self.table!.delegate = self
        self.table!.dataSource = self
        self.table!.backgroundColor = nil
        self.view.addSubview(self.table!)
        
        self.showDataForAlbumAt(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showDataForAlbumAt(index: Int) {
        if index < self.allAlbums.count {
            currentAlbum = self.allAlbums[index].tr_tableRepresentation()
            currentAlbumIndex = index
        } else {
            currentAlbum = nil
        }
        
        self.table!.reloadData()
    }
    
    // MARK: table's data source & delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAlbum!["titles"]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = table!.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        
        let row = indexPath.row
        cell!.textLabel!.text = self.currentAlbum!["titles"]![row]
        cell!.detailTextLabel!.text = self.currentAlbum!["values"]![row]
        
        return cell!
    }
}

