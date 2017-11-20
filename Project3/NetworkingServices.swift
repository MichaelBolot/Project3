//
//  NetworkingServices.swift
//  Project3
//
//  Created by Michael Bolot on 11/14/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import Foundation

class NetworkingServices{
    
    static var shared = NetworkingServices()
    
    var users = ["Template"] //userlist to be stored in the class
    var messages = [Message]()
    var currentUser = ""  //currentUser so that messages can have an accurate source
    
    var sourceUrl = "https://obscure-crag-65480.herokuapp.com/"

    struct User: Codable {
        var name: String
        var password: String
    }
    
    struct PrivateMessage: Codable{
        var to: String
        var from: String
        var message: Message
    }
    
    struct Message: Codable{
        var user: String
        var text: String
        var date: Date?
        var imgURL: URL?
        var id: String?
        var replyTo: String?
        var likedBy: [String]?
    }

    struct Token: Codable{
        var token: String?
    }
    
    struct Like: Codable{
        var likedMessageID: String
    }

    var token = Token(token: "testThings")

    func testLogin(){
        //function to test login, has my info hardcoded onto it
        let user = User(name: "michael.bolot", password: "kgcegk7r")
        let url = URL(string: sourceUrl + "login")!
        var request = URLRequest(url: url)
        request.httpBody = try! JSONEncoder().encode(user)
        request.httpMethod = "POST"
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
        }
        task.resume()
        
    }

    func getToken(user: User, completion:@escaping (String?)->()){
        //gets the token for the user
        let url = URL(string: sourceUrl + "login")!
        var request = URLRequest(url: url)
        
        request.addValue("tokenValue", forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(user)
        var tkInter: Token?
        let postTask = URLSession(configuration: .ephemeral).dataTask(with: request){(data, response, error) in
            if let hr = response as? HTTPURLResponse {
                if hr.statusCode != 200 {
                    completion(nil)
                    //login has failed, so complete with nil
                }
            }
            if(data == nil){
                //return/complete if no data
                completion(nil)
                return
            }
            //decode token
            tkInter = try? JSONDecoder().decode(Token.self, from: data!)
            if(tkInter != nil){
                self.token = tkInter!
                self.currentUser = user.name
            }
            completion(tkInter?.token)
        }
        postTask.resume()
    }

    func getUsers(completion:@escaping ([String])->()){
        //gets the users for use in the selectionViewController
        let url = URL(string: sourceUrl + "users")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        
        var userList = ["Bull", "garbage", "trash"] //default string array, almost immediately filled with real values
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            userList = try! JSONDecoder().decode([String].self, from: data!)
            self.users = userList
            completion(self.users)
        }
        task.resume()
    }
    
    func getMessages(completion:@escaping ([Message])->()){
        //function to get General messages
        let url = URL(string: sourceUrl + "messages")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        
        var messages = [Message]()
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            messages = try! JSONDecoder().decode([Message].self, from: data!)
            self.messages = messages
            completion(messages)
        }
        task.resume()
        
    }
    
    func postMessage(message: Message, completion:@escaping()->()){
        //function to post general messages
        let url = URL(string: sourceUrl + "messages")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        request.httpMethod = "Post"
        request.httpBody = try! JSONEncoder().encode(message)
        let task = URLSession(configuration: .ephemeral).dataTask(with: request){(data, response, error) in
            completion()
        }
        task.resume()
    }
    
    func postLike(messageID: String, completion:@escaping ()->()){
        //function to post like, not used for dms
        let url = URL(string: sourceUrl + "like")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        let like = Like(likedMessageID: messageID)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(like)
        let task = URLSession(configuration: .ephemeral).dataTask(with: request){(data, response, error) in
            completion()
        }
        task.resume()
    }
    
    func getPrivateMessages(completion:@escaping ([PrivateMessage])->()){
        //gets privateMessages for the user
        let url = URL(string: sourceUrl + "direct")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        var messages = [PrivateMessage]()
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            messages = try! JSONDecoder().decode([PrivateMessage].self, from: data!)
            completion(messages)
        }
        task.resume()
    }
    
    func postPrivateMessage(to: String, message: Message, completion:@escaping ()->()){
        //posts the private messages
        let url = URL(string: sourceUrl + "direct")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        var privateMessage = PrivateMessage(to: to, from: self.currentUser, message: message)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(privateMessage)
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            completion()
        }
        task.resume()
        
    }
}
