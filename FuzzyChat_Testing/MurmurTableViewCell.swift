//
//  MurmurTableViewCell.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/23.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class MurmurTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
