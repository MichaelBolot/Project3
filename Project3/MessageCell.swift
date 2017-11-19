//
//  MessageCell.swift
//  Project3
//
//  Created by Michael Bolot on 11/16/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell{
    var message: NetworkingServices.Message?
    
    
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func configure(message: NetworkingServices.Message){
        self.message = message
        senderLabel.text = message.user
        messageContent.text = message.text
        print(messageContent.text)
        dateLabel.text = message.date!.description
    }
    
}
