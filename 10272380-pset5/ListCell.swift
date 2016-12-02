//
//  ListCell.swift
//  10272380-pset5
//
//  Created by Quinten van der Post on 02/12/2016.
//  Copyright © 2016 Quinten van der Post. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    var listId = Int64()
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
