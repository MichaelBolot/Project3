//
//  ViewController.swift
//  Project3
//
//  Created by Michael Bolot on 11/9/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var errorTextView: UITextView!
    
    @IBOutlet weak var postField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // grabs the username from standards, and if it exists, tries to grab the password
        //Note: This only works some of the time. Not sure why
        let username = UserDefaults.standard.value(forKey: "username") as? String
        if(username != nil){
            let password = UserDefaults.standard.value(forKey: username!) as? String
            let user = NetworkingServices.User(name: username!, password: password!)
            NetworkingServices.shared.getToken(user: user){rtoken in
                if(rtoken == nil){
                    //uses main thread to display error message
                    DispatchQueue.main.async{
                        self.errorTextView.text = "Invalid Username/Password Combination, retry"
                    }
                    
                }else{
                    DispatchQueue.main.async{
                        //if the username/password exists, it logs in for the user and automatically moves to the next vc
                        let username = self.postField.text
                        let password = self.passwordField.text
                        UserDefaults.standard.set(username ?? "", forKey: "username")
                        UserDefaults.standard.set(password, forKey: username!)
                        UserDefaults.standard.synchronize()
                        let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                        self.present(tabVC, animated: true, completion: nil)
                    }
                }
        
            }
        }
        
        
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postFieldEnter(_ sender: Any) {
        //allows one to press enter to move from the first field (user) to the second
        passwordField.becomeFirstResponder()
    }
    

    @IBAction func passwordFieldEnter(_ sender: Any) {
        //attempts to get token as long as some information is present in the fields
        if(postField.text == ""){
            return
        }
        if(passwordField.text == ""){
            return
        }
        let user = NetworkingServices.User(name: postField.text!, password: passwordField.text!)
        NetworkingServices.shared.getToken(user: user){rtoken in
            if(rtoken == nil){
                //uses main thread to display error message
                DispatchQueue.main.async{
                    //if there is no token an error message shows up
                    self.errorTextView.text = "Invalid Username/Password Combination, retry"
                }
                
            }else{
                DispatchQueue.main.async{
                    //if there is a valid token, it stores the data and moves on to the next VC
                    let username = self.postField.text
                    let password = self.passwordField.text
                    UserDefaults.standard.set(username ?? "", forKey: "username")
                    UserDefaults.standard.set(password, forKey: username!)
                    UserDefaults.standard.synchronize()
                
                    let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(tabVC, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
}


