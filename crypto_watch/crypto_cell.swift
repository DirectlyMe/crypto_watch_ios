//
//  crypto_cell.swift
//  crypto_watch
//
//  Created by Jack Hansen on 9/29/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import UIKit

class crypto_cell: UITableViewCell {

    @IBOutlet weak var cellTitle: UITextField!
    @IBOutlet weak var cellPrice: UITextField!
    @IBOutlet weak var cellChange: UITextField!
    @IBOutlet weak var cellVolume: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
