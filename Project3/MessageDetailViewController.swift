//
//  MessageDetailViewController.swift
//  Project3
//
//  Created by Michael Bolot on 11/17/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit
class MessageDetailViewController: UIViewController{
    var message: NetworkingServices.Message?
    var uniqueLikers = [String]()
    var isdmReply = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageContentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesNumLabel: UILabel!
    @IBOutlet weak var likedByLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likedByLabel.text = "Liked By: "
        configure()
    }
    
    func configure(){
        nameLabel.text = self.message!.user
        dateLabel.text = self.message!.date?.description
        messageContentLabel.text = self.message!.text
        let numLikes = message!.likedBy?.count ?? 0
        likesNumLabel.text = String(numLikes)
        if(numLikes > 0){
            for entry in self.message!.likedBy!{
                if self.uniqueLikers.contains(entry){
                    continue
                }else{
                    self.uniqueLikers.append(entry)
                }
            }
            var likers = "Liked By: "
            for entry in self.uniqueLikers{
                likers += entry
                likers += ", "
            }
            likedByLabel.text = likers
        }
        if message!.imgURL != nil{
            imageService().imageForURL(url: message!.imgURL){image in
                DispatchQueue.main.async{
                    self.imageView.image = image
                }
            }
        }
        
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        if isdmReply == true{
            return
        }
        NetworkingServices.shared.postLike(messageID: message!.id!){
            DispatchQueue.main.async{
                self.likesNumLabel.text = String(Int(self.likesNumLabel.text!)! + 1)
                let currentUser = NetworkingServices.shared.currentUser
                if self.uniqueLikers.contains(currentUser){
                    //don't add the username to the unique like list if the user has already liked the post
                }else{
                    self.uniqueLikers.append(currentUser)
                    let newText = self.likedByLabel.text!
                    self.likedByLabel.text = newText + currentUser
                }
            }
        }
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sendVC = storyboard.instantiateViewController(withIdentifier: "MessageSendViewController") as! MessageSendViewController
        sendVC.replyTo = self.message!.id!
        if isdmReply{
            sendVC.recipient = message!.user
        }else{
            sendVC.recipient = "General"
        }
        sendVC.isTemporaryVC = true
        present(sendVC, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
}
