//
//  ViewController.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 15/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate {
    private var table: UITableView?
    private var allAlbums: [Album] = [Album]()
    private var currentAlbum: [String: [String]]?
    private var currentAlbumIndex: Int = 0
    private var scroller: HorizontalScroller?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.81, blue: 0.87, alpha: 1)
        
        self.table = UITableView(frame: CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height - 120), style: UITableViewStyle.Grouped)
        self.table!.delegate = self
        self.table!.dataSource = self
        self.table!.backgroundColor = nil
        self.view.addSubview(self.table!)
        
        self.scroller = HorizontalScroller(frame: CGRectMake(0, 0, self.view.frame.width, 120), delegate: self)
        self.scroller!.backgroundColor = UIColor(red: 0.24, green: 0.35, blue: 0.49, alpha: 1.0)
        self.view.addSubview(self.scroller!)
        
        self.reloadScroller()
        
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
    
    func reloadScroller() {
        self.allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        if self.currentAlbumIndex < 0 {
            self.currentAlbumIndex = 0
        }
        
        if self.currentAlbumIndex >= self.allAlbums.count {
            self.currentAlbumIndex = self.allAlbums.count - 1
        }
        
        self.scroller!.reloadData()
        self.showDataForAlbumAt(self.currentAlbumIndex)
    }
    
    // MARK: HorizontalScrollerDelegate's methods
    func horizontalScroller(horizontalScroller: HorizontalScroller, clickedViewAtIndex index: Int) {
        self.showDataForAlbumAt(index)
    }
    
    func horizontalScroller(horizontalScroller: HorizontalScroller, viewAtIndex index: Int) -> UIView {
        let album = self.allAlbums[index]
        return AlbumView(frame: CGRectMake(0, 0, 100, 100), albumCover: album.coverUrl)
    }
    
    func numberOfViewsForHorizontalScroller(horizontalScroller: HorizontalScroller) -> Int {
        return self.allAlbums.count
    }
    
    func initialViewIndexForhorizontalScroller(horizontalScroller: HorizontalScroller) -> Int {
        return 1
    }
}

