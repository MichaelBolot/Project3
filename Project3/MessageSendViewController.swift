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
        print(recipient)
        recipientLabel.text = recipient
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if isTemporaryVC{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.recipient = "Recipient: "
            self.recipientLabel.text = self.recipient
            self.imageField.text = ""
            self.messageField.text = ""
            
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        var reply: String?
        var imgInfo: URL?
        if replyTo == ""{
            reply = nil
        }else{
            reply = replyTo
        }
        
        if imageField.text == ""{
            imgInfo = nil
        }else{
            imgInfo = URL(string: imageField.text!)
        }
        
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
            //imgInfo = nil no images in dms
            let message = NetworkingServices.Message(user: NetworkingServices.shared.currentUser,
                                                     text: messageField.text ?? "",
                                                     date: Date.init(),
                                                     imgURL: imgInfo,
                                                     id: nil,
                                                     replyTo: reply,
                                                     likedBy: nil)
            let to = self.recipientLabel.text
            let from = NetworkingServices.shared.currentUser
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectionVC = storyboard.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        selectionVC.previousVC = self
        present(selectionVC, animated: true, completion: nil)
    }
}
