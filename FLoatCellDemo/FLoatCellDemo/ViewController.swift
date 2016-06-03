//
//  AppDelegate.swift
//  MGBeseTableView
//
//  Created by ghost on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var sourceIndexPath: NSIndexPath!
    private var fromIndexPath: NSIndexPath!
    private var snapView : UIView!
    private var indexPath: NSIndexPath!
    
    private var heros : [Heros]?{
        didSet{
            
        }
    }
    @IBOutlet weak var baseTableView: BaseTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("heros", ofType: "plist")
        let array = NSArray(contentsOfFile: path!) as! [[String: AnyObject]]
        heros = array.map{Heros(dict:$0)}
        
        baseTableView.estimatedRowHeight = 44
        baseTableView.rowHeight = UITableViewAutomaticDimension
        GestrureAdd()
        
    }

    func GestrureAdd() {
        let LoogPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addGestureStats(_:)))
        LoogPress.minimumPressDuration = 1
        baseTableView.addGestureRecognizer(LoogPress)
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
        
        let point = LoogPerss.locationInView(baseTableView)
        
        indexPath = baseTableView.indexPathForRowAtPoint(point)
        if let cell = baseTableView.cellForRowAtIndexPath(indexPath) {
            sourceIndexPath = indexPath
            let snapView = self.snapView(cell)
            self.snapView = snapView
            baseTableView.addSubview(snapView)
            
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
        
        let point = LoogPerss.locationInView(baseTableView)
        indexPath = baseTableView.indexPathForRowAtPoint(point)
        snapView.center = CGPointMake(snapView.center.x, point.y)
        
        fromIndexPath = NSIndexPath(index: 0)
        fromIndexPath = sourceIndexPath
        
        if fromIndexPath != indexPath {
            baseTableView.beginUpdates()
            let temp = heros![indexPath.row]
            heros![indexPath.row] = heros![fromIndexPath.row]
            heros![fromIndexPath.row] = temp
            baseTableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: indexPath)
            baseTableView.endUpdates()
            sourceIndexPath = indexPath
        }
        
        let stop: CGFloat = 64
        
        if let parenView = baseTableView.superview{
            let parenPos = baseTableView.convertPoint(point, toView: parenView)
            if parenPos.y > parenView.bounds.height - stop {
                var offset = baseTableView.contentOffset
                offset.y += (parenPos.y - baseTableView.bounds.height + stop)
                print(parenPos.y - baseTableView.bounds.height + stop)
                if offset.y > baseTableView.contentSize.height - baseTableView.bounds.height {
                    offset.y = baseTableView.contentSize.height - baseTableView.bounds.height
                }
                baseTableView.setContentOffset(offset, animated: false)
            } else if parenPos.y <= stop {
                var offset = baseTableView.contentOffset
                offset.y -= (stop - parenPos.y)
                if offset.y < 0 {
                    offset.y = 0
                }
                baseTableView.setContentOffset(offset, animated: false)
            }
        }
    }
    
    func addGesturStatsEndedAndCancelled(LoogPerss: UILongPressGestureRecognizer) {
        
        let cell = baseTableView.cellForRowAtIndexPath(fromIndexPath)!
        cell.alpha = 0
        cell.hidden = false
        
        UIView.animateWithDuration(0.25, animations: { 
            self.snapView.center = cell.center
            self.snapView.alpha = 0
            cell.alpha = 1
            }) { (_) in
                self.snapView = nil
                self.sourceIndexPath = nil
                self.baseTableView.performSelector(#selector(UITableView.reloadData), withObject: nil, afterDelay: 0.5)
        }
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

extension ViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heros!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! HeroTableViewCell
        let models = heros![indexPath.row]
        cell.heros = models
        return cell
    }
}

