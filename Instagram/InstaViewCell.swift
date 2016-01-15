//
//  instaViewCell.swift
//  Instagram
//
//  Created by Varun Vyas on 14/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit

class InstaViewCell: UITableViewCell {

    @IBOutlet weak var instaImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
