//
//  ItemCell.swift
//  10272380-pset5
//
//  Created by Quinten van der Post on 02/12/2016.
//  Copyright © 2016 Quinten van der Post. All rights reserved.
//

import UIKit

protocol ItemCellDelegate {
    func todoCompletionTapped(cell: ItemCell)
}

class ItemCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var completionCheck: UIButton!
    var listId: Int64?
    var itemId: Int64?
    var completion: Bool?
    var delegate: ItemCellDelegate?
    

    @IBAction func todoCompletionTapped(_ sender: Any) {
        if let _ = delegate {
            delegate?.todoCompletionTapped(cell: self)
            updateImage()
        }
        
    }
    
    func updateImage() {
        if completion == true {
            completionCheck.setImage(UIImage(named: "checkMark"), for: .normal)
        }
        else {
            completionCheck.setImage(nil, for: .normal)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
