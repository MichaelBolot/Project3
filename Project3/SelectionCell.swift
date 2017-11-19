//
//  SelectionCell.swift
//  Project3
//
//  Created by Michael Bolot on 11/18/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit
class SelectionCell: UITableViewCell{
    
    @IBOutlet weak var userLabel: UILabel!
    func configure(user: String){
        self.userLabel.text = user
    }
    
}
