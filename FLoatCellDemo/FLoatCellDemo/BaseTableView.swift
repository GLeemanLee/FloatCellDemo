//
//  AppDelegate.swift
//  FLoatCellDemo
//
//  Created by ghost on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {
    
    private var sourceIndexPath: NSIndexPath!
    private var fromIndexPath: NSIndexPath!
    private var snapView : UIView!
    private var indexPath: NSIndexPath!
    
    var heros : [Heros]?{
        didSet{
            
        }
    }
    
    
    func GestrureAdd() {
        let LoogPress = UILongPressGestureRecognizer(target: self, action: #selector(BaseTableView.addGestureStats(_:)))
        LoogPress.minimumPressDuration = 1
        addGestureRecognizer(LoogPress)
    }
    
    func addGestureStats(LoogPress: UILongPressGestureRecognizer) {
        if LoogPress.state == UIGestureRecognizerState.Began {
            addGesturStatsBegan(LoogPress)
        }
        
        if LoogPress.state == UIGestureRecognizerState.Changed {
            addGesturStatsChanged(LoogPress)
        }
        
        if LoogPress.state == UIGestureRecognizerState.Ended || LoogPress.state == UIGestureRecognizerState.Cancelled {
            
            addGesturStatsEndedAndCancelled(LoogPress)
            
        }
    }
    
    func addGesturStatsBegan(LoogPerss: UILongPressGestureRecognizer) {
        
        let point = LoogPerss.locationInView(self)
        
       indexPath = self.indexPathForRowAtPoint(point)
        if let cell = self.cellForRowAtIndexPath(indexPath) {
            sourceIndexPath = indexPath
            let snapView = self.snapView(cell)
            self.snapView = snapView
            addSubview(snapView)
            
            UIView.animateWithDuration(0.25, animations: {
                // 选中Cell跳出放大效果
                snapView.alpha = 0.95
                snapView.center = CGPointMake(cell.center.x, point.y)
                snapView.transform = CGAffineTransformMakeScale(1.05, 1.05)
                
                cell.alpha = 0
                }, completion: { (completed) -> Void in
                    cell.hidden = true
                    cell.alpha = 1
            })
        }else{
            sourceIndexPath = nil
            snapView = nil
        }
    }
    
    func addGesturStatsChanged(LoogPerss: UILongPressGestureRecognizer) {
        
        let point = LoogPerss.locationInView(self)
        indexPath = self.indexPathForRowAtPoint(point)
        snapView.center = CGPointMake(snapView.center.x, point.y)
        
        fromIndexPath = NSIndexPath(index: 0)
        
        if fromIndexPath == sourceIndexPath {
            if fromIndexPath != indexPath {
                self.beginUpdates()
                let temp = heros![indexPath.row]
                heros![indexPath.row] = heros![fromIndexPath.row]
                heros![fromIndexPath.row] = temp
                self.moveRowAtIndexPath(fromIndexPath, toIndexPath: indexPath)
                self.endUpdates()
                sourceIndexPath = indexPath
            }
        }
        
        let stop: CGFloat = 64
        
        if let parenView = self.superview{
            let parenPos = self.convertPoint(point, toView: parenView)
            
            if parenPos.y > parenView.bounds.height - stop {
                var offset = self.contentOffset
                offset.y += (parenPos.y - self.bounds.height + stop)
                if offset.y > self.contentSize.height - self.bounds.height {
                    offset.y = self.contentSize.height - self.bounds.height
                }
                self.setContentOffset(offset, animated: false)
            } else if parenPos.y <= stop {
                var offset = self.contentOffset
                offset.y -= (stop - parenPos.y)
                if offset.y < 0 {
                    offset.y = 0
                }
                self.setContentOffset(offset, animated: false)
            }
        }
    }
    
    func addGesturStatsEndedAndCancelled(LoogPerss: UILongPressGestureRecognizer) {
        
        
        
    }
    
    func snapView(view: UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapShot = UIImageView(image: image)
        snapShot.layer.masksToBounds = false;
        snapShot.layer.cornerRadius = 0;
        snapShot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
        snapShot.layer.shadowOpacity = 0.4;
        snapShot.layer.shadowRadius = 5;
        snapShot.frame = view.frame
        return snapShot
    }
    
    
    
}
