//
//  SelectionViewController.swift
//  Project3
//
//  Created by Michael Bolot on 11/18/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit
class SelectionViewController: UIViewController{
    var userList = [String]()
    var previousVC = MessageSendViewController()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gets users and displays them
        NetworkingServices.shared.getUsers{users in
            DispatchQueue.main.async{
                //adds "General" so that there is an option for general chat
                self.userList = ["General"] + users
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            }
        }
    
    }
}


extension SelectionViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        previousVC.recipient = userList[indexPath.item]
        previousVC.configure()
        dismiss(animated: true, completion: nil)
    }
}
extension SelectionViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        cell.configure(user: userList[indexPath.item])
        return cell
    }
    
}
