//
//  ViewController.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 15/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate {
    private var table: UITableView?
    private var allAlbums: [Album] = [Album]()
    private var currentAlbum: [String: [String]]?
    private var currentAlbumIndex: Int = 0
    private var scroller: HorizontalScroller?
    private var toolbar: UIToolbar?
    private var undoStack: [Command] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.81, blue: 0.87, alpha: 1)
        
        self.table = UITableView(frame: CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height - 120), style: UITableViewStyle.Grouped)
        self.table!.delegate = self
        self.table!.dataSource = self
        self.table!.backgroundColor = nil
        self.view.addSubview(self.table!)
        
        self.loadPreviousState()
        
        self.scroller = HorizontalScroller(frame: CGRectMake(0, 0, self.view.frame.width, 120), delegate: self)
        self.scroller!.backgroundColor = UIColor(red: 0.24, green: 0.35, blue: 0.49, alpha: 1.0)
        
        self.reloadScroller()
        self.view.addSubview(self.scroller!)
        
        self.showDataForAlbumAt(self.currentAlbumIndex)
        
        self.toolbar = UIToolbar()
        let undoItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Undo, target: self, action: "undoAction")
        undoItem.enabled = false
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let delete = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteAlbum")
        if self.allAlbums.count <= 0 {
            delete.enabled = false
        }
        self.toolbar!.setItems([undoItem, space, delete], animated: true)
        self.view.addSubview(self.toolbar!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveCurrentState", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        self.toolbar!.frame = CGRectMake(0, self.view.frame.height - 44, self.view.frame.width, 44)
        self.table!.frame = CGRectMake(0, 130, self.view.frame.width, self.view.frame.height - 200)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAlbum(album: Album, index: Int) {
        LibraryAPI.sharedInstance.addAlbum(album, index: index)
        self.currentAlbumIndex = index
        self.reloadScroller()
        
        if LibraryAPI.sharedInstance.getAlbums().count > 0 {
            var deleteItem: UIBarButtonItem = self.toolbar!.items![2] as! UIBarButtonItem
            deleteItem.enabled = true
        }
    }
    
    func deleteAlbum() {
        if self.currentAlbumIndex < 0 || self.currentAlbumIndex >= self.allAlbums.count {
            return
        }
        
        let deletedAlbum = self.allAlbums[self.currentAlbumIndex]
        let deletedAlbumIndex = self.currentAlbumIndex
        
        let undoCommand = Command(target: self, f: {
            (args) in
            self.addAlbum(deletedAlbum, index: deletedAlbumIndex)
            return nil
        }, args: [deletedAlbum, deletedAlbumIndex])
        
        self.undoStack.append(undoCommand)
        var undoItem: UIBarButtonItem = self.toolbar!.items![0] as! UIBarButtonItem
        undoItem.enabled = true
        
        LibraryAPI.sharedInstance.deleteAlbum(self.currentAlbumIndex)
        self.reloadScroller()
        
        if LibraryAPI.sharedInstance.getAlbums().count <= 0 {
            var deleteItem: UIBarButtonItem = self.toolbar!.items![2] as! UIBarButtonItem
            deleteItem.enabled = false
        }
    }
    
    func undoAction() {
        if self.undoStack.count > 0 {
            let undoCommand = self.undoStack.removeLast()
            undoCommand.execute(nil)
        }
        
        if self.undoStack.count == 0 {
            var undoItem: UIBarButtonItem = self.toolbar!.items![0] as! UIBarButtonItem
            undoItem.enabled = false
        }
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
    
    // MARK: table's data source & delegate
    func showDataForAlbumAt(index: Int) {
        if index >= 0 && index < self.allAlbums.count {
            currentAlbum = self.allAlbums[index].tr_tableRepresentation()
            currentAlbumIndex = index
        } else {
            currentAlbum = nil
        }
        
        self.table!.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentAlbum != nil {
            return currentAlbum!["titles"]!.count
        } else {
            return 0
        }
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
        return self.currentAlbumIndex
    }
    
    // MARK: Memento
    func saveCurrentState() {
        NSUserDefaults.standardUserDefaults().setInteger(self.currentAlbumIndex, forKey: "currentAlbumIndex")
        LibraryAPI.sharedInstance.saveAlbums()
    }
    
    func loadPreviousState() {
        self.currentAlbumIndex = NSUserDefaults.standardUserDefaults().integerForKey("currentAlbumIndex")
    }
}

