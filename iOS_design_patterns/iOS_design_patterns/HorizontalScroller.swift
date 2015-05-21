//
//  HorizontalScroller.swift
//  iOS_design_patterns
//
//  Created by Le Hong Trieu on 19/5/15.
//  Copyright (c) 2015 Milna. All rights reserved.
//

import UIKit

@objc protocol HorizontalScrollerDelegate {
    func numberOfViewsForHorizontalScroller(horizontalScroller: HorizontalScroller) -> Int
    
    func horizontalScroller(horizontalScroller: HorizontalScroller, viewAtIndex index: Int) -> UIView
    
    func horizontalScroller(horizontalScroller: HorizontalScroller, clickedViewAtIndex index: Int)
    
    optional func initialViewIndexForhorizontalScroller(horizontalScroller: HorizontalScroller) -> Int
}

class HorizontalScroller: UIView, UIScrollViewDelegate {
    private static let VIEW_PADDING = CGFloat(10)
    private static let VIEW_DIMENSIONS = CGFloat(100)
    private static let VIEWS_OFFSET = CGFloat(100)
    
    unowned var delegate: HorizontalScrollerDelegate
    var scroller: UIScrollView
    
    init(frame: CGRect, delegate: HorizontalScrollerDelegate) {
        self.delegate = delegate
        self.scroller = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super.init(frame: frame)
        
        self.scroller.delegate = self
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "scrollerTappedWithGesture:")
        self.scroller.addGestureRecognizer(tapRecognizer)
        
        self.addSubview(self.scroller)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollerTappedWithGesture(gesture: UITapGestureRecognizer) {
        let location:CGPoint = gesture.locationInView(gesture.view)
        
        for var i = 0; i < self.delegate.numberOfViewsForHorizontalScroller(self); i++ {
            // TODO: do not feel happy with this, as the scroller may contain other subviews
            // which we do not concern with checking whether they are tapped.
            let view: UIView = self.scroller.subviews[i] as! UIView
            if CGRectContainsPoint(view.frame, location) {
                self.delegate.horizontalScroller(self, clickedViewAtIndex: i)
                self.scroller.setContentOffset(CGPointMake(view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2, 0), animated:true)
                
                break
            }
        }
    }
    
    func reloadData() {
        for (index, subview) in enumerate(self.scroller.subviews) {
            subview.removeFromSuperview()
        }
        
        var xVal = HorizontalScroller.VIEWS_OFFSET
        for var i = 0; i < self.delegate.numberOfViewsForHorizontalScroller(self); i++ {
            xVal += HorizontalScroller.VIEW_PADDING
            let view = self.delegate.horizontalScroller(self, viewAtIndex: i)
            view.frame = CGRectMake(xVal, HorizontalScroller.VIEW_PADDING, HorizontalScroller.VIEW_DIMENSIONS, HorizontalScroller.VIEW_DIMENSIONS)
            self.scroller.addSubview(view)
            
            xVal += HorizontalScroller.VIEW_DIMENSIONS + HorizontalScroller.VIEW_PADDING
        }
        
        self.scroller.contentSize = CGSizeMake(xVal + HorizontalScroller.VIEWS_OFFSET, self.frame.size.height)
        
        if let initialView = self.delegate.initialViewIndexForhorizontalScroller?(self) {
            if initialView >= 0 && initialView < self.scroller.subviews.count {
                let view: UIView = self.scroller.subviews[initialView] as! UIView
                self.scroller.setContentOffset(CGPointMake(view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2, 0), animated:true)
            }
        }
    }
    
    override func didMoveToSuperview() {
        self.reloadData()
    }
    
    func centerCurrentView() {
        var xFinal = self.scroller.contentOffset.x + self.frame.width / 2 - HorizontalScroller.VIEWS_OFFSET - HorizontalScroller.VIEW_PADDING
        let viewIndex = Int(xFinal / (HorizontalScroller.VIEW_DIMENSIONS + 2 * HorizontalScroller.VIEW_PADDING))
        
        let view: UIView = self.scroller.subviews[viewIndex] as! UIView
        self.scroller.setContentOffset(CGPointMake(view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2, 0), animated:true)
        
        self.delegate.horizontalScroller(self, clickedViewAtIndex: viewIndex)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.centerCurrentView()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.centerCurrentView()
        }
    }
}