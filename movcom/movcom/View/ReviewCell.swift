//
//  ReviewCell.swift
//  movcom
//
//  Created by Ivan on 15/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var reviewContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
