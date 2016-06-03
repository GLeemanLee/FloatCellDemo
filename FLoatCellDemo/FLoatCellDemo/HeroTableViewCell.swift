//
//  AppDelegate.swift
//  MGBeseTableView
//
//  Created by ghost on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class HeroTableViewCell: UITableViewCell {
    
    @IBOutlet weak var matterView: UILabel!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var heros : Heros?{
        didSet{
            matterView.text = heros!.intro
            titileLabel.text = heros!.name
            iconImage.image = UIImage(named: heros!.icon!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        matterView.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
