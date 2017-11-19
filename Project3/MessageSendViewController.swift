//
//  MessageSendViewController.swift
//  Project3
//
//  Created by Michael Bolot on 11/18/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit
class MessageSendViewController: UIViewController{
    
    var recipient = "Recipient: "
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    func configure(){
        print(recipient)
        recipientLabel.text = recipient
    }
    @IBAction func selectButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectionVC = storyboard.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        present(selectionVC, animated: true, completion: nil)
        configure()
    }
}
