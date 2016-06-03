//
//  AppDelegate.swift
//  MGBeseTableView
//
//  Created by ghost on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class Heros: NSObject {
    
    var icon: String?
    var intro: String?
    var name: String?

    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys = ["icon", "intro","name"]
        let dict = dictionaryWithValuesForKeys(keys)
        return "\(dict)"
    }

}
