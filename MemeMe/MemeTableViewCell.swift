//
//  MemeTableViewCell.swift
//  MemeMe 1.0
//
//  Created by Noha on 02.08.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeText: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
