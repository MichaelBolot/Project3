//
//  PrivateMessageViewController.swift
//  Project3
//
//  Created by Michael Bolot on 11/19/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit
//Class for viewing the private(Direct) messages in a table
class PrivateMessageViewController: UIViewController{
    @IBOutlet var tableView: UITableView!
    
    var messages = [NetworkingServices.Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gets the pms and displays them
        NetworkingServices.shared.getPrivateMessages(){privateMessages in
            DispatchQueue.main.async{
                var messages = [NetworkingServices.Message]()
                for entry in privateMessages{
                    //appends the message for each entry to the messges list
                    messages.append(entry.message)
                }
                self.messages = messages
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension PrivateMessageViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reuses the message cell for the private messages
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.configure(message: messages[indexPath.item])
        return cell
    }
    
}

extension PrivateMessageViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //instantiages the detail view controller for "closer inspection" of the pm
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageDetailViewController = storyboard.instantiateViewController(withIdentifier: "MessageDetailViewController") as! MessageDetailViewController
        
        //sets the isdmReply so that likes will be disabled and the reply button will bring up a vc with the message sender as the recipient
        messageDetailViewController.isdmReply = true
        messageDetailViewController.message = messages[indexPath.item]
        present(messageDetailViewController, animated: true, completion: nil)
    }
}

