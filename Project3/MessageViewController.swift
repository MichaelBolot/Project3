//
//  MessageViewController.swift
//  Project3
//
//  Created by Michael Bolot on 11/16/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit
class MessageViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    var messages = [NetworkingServices.Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingServices.shared.getMessages(){messages in
            DispatchQueue.main.async{
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
extension MessageViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.configure(message: messages[indexPath.item])
        return cell
    }
    
}

extension MessageViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageDetailViewController = storyboard.instantiateViewController(withIdentifier: "MessageDetailViewController") as! MessageDetailViewController
        messageDetailViewController.message = messages[indexPath.item]
        present(messageDetailViewController, animated: true, completion: nil)
    }
}

