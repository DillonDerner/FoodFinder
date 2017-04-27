//
//  NearMeTableViewCellController.swift
//  FoodFinder
//
//  Created by user127006 on 4/27/17.
//  Copyright © 2017 Milan. All rights reserved.
//

import UIKit

class NearMeTableViewCellController: UITableViewCell {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
