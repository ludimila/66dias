//
//  CustomCell.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 24/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendNumberOfGoals: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separator.backgroundColor = UIColor(netHex: 0x24174B)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
