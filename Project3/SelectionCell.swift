//
//  SelectionCell.swift
//  Project3
//
//  Created by Michael Bolot on 11/18/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit
class SelectionCell: UITableViewCell{
    //simple selection cell for seleting a user to send messages to
    @IBOutlet weak var userLabel: UILabel!
    func configure(user: String){
        self.userLabel.text = user
    }
    
}
