//
//  CustomScoreCell.swift
//  PhotoPuzzle
//
//  Created by Dinesh Yeligandla on 11/21/19.
//  Copyright © 2019 Ramon Rodriguez. All rights reserved.
//

import UIKit

class CustomScoreCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblElapsedTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
