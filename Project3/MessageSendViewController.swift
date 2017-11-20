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
    var replyTo = ""
    var isTemporaryVC = false
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    func configure(){
        recipientLabel.text = recipient
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if isTemporaryVC{
            //if the vc is temporary (meaning called by another vc and not the original one in the tab bar), it is dismissed upon cancel
            self.dismiss(animated: true, completion: nil)
        }else{
            //otherwise, the info is just reset
            self.recipient = "Recipient: "
            self.recipientLabel.text = self.recipient
            self.imageField.text = ""
            self.messageField.text = ""
            
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        //after send button is tapped, send the message
        var reply: String?
        var imgInfo: URL?
        //if the replyTo field hasn't changed, set the reply to nil
        //otherwise, set the reply to replyTo
        if replyTo == ""{
            reply = nil
        }else{
            reply = replyTo
        }
        //if imageField hasn't changed, set imgURL (in message) to nil
        //Otherwise, make the imgURL
        if imageField.text == ""{
            imgInfo = nil
        }else{
            imgInfo = URL(string: imageField.text!)
        }
        
        //code for if the message is a general message
        if recipientLabel.text == "General"{
            let message = NetworkingServices.Message(user: NetworkingServices.shared.currentUser,
                                             text: messageField.text ?? "",
                                             date: Date.init(),
                                             imgURL: imgInfo,
                                             id: nil,
                                             replyTo: reply,
                                             likedBy: nil)
            NetworkingServices.shared.postMessage(message: message){
                DispatchQueue.main.async {
                    self.messageField.text = "MessageSent"
                    self.imageField.text = nil
                    self.recipient = "Recipient: "
                    self.recipientLabel.text = "Recipient: "
                    if self.isTemporaryVC{
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }else{
            //message is a pm, so use that structure instead
            let message = NetworkingServices.Message(user: NetworkingServices.shared.currentUser,
                                                     text: messageField.text ?? "",
                                                     date: Date.init(),
                                                     imgURL: imgInfo,
                                                     id: nil,
                                                     replyTo: reply,
                                                     likedBy: nil)
            let to = self.recipientLabel.text
            //checks if a recipient is specified, and if it is, sends the pm
            if to != "Recipient: "{
                NetworkingServices.shared.postPrivateMessage(to: to!, message: message){
                    DispatchQueue.main.async {
                        self.messageField.text = "MessageSent"
                        self.imageField.text = nil
                        self.recipient = "Recipient: "
                        self.recipientLabel.text = "Recipient: "
                        if self.isTemporaryVC{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        //if the select button is tapped, it brings up the view controller with options for pm target
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectionVC = storyboard.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        //passess itself to the "next" vc in order to get the answer back after the selection is made
        selectionVC.previousVC = self
        present(selectionVC, animated: true, completion: nil)
    }
}
