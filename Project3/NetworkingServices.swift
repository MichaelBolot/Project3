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
    
    var users = ["Template"]
    var messages = [Message]()
    var currentUser = ""
    
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
        let user = User(name: "michael.bolot", password: "kgcegk7r")
        let url = URL(string: sourceUrl + "login")!
        var request = URLRequest(url: url)
        request.httpBody = try! JSONEncoder().encode(user)
        request.httpMethod = "POST"
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            print(response)
            print(data)
            print(error)
        }
        task.resume()
        
    }

    func getToken(user: User, completion:@escaping (String?)->()){
        //let user = User(name: "michael.bolot", password: "kgcegk7r")
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
                    print("LOGIN STATUS \(hr.statusCode)")
                }
            }
            if(data == nil){
                completion(nil)
                return
            }
            tkInter = try? JSONDecoder().decode(Token.self, from: data!)
            print("TOKEN IS")
            print(tkInter?.token)
            if(tkInter != nil){
                self.token = tkInter!
                self.currentUser = user.name
            }
            completion(tkInter?.token)
        }
        postTask.resume()
        //        return tkInter.token
    }

    func getUsers(completion:@escaping ([String])->()){
        print("THE TOKEN NOW IS")
        print(self.token.token)
        let url = URL(string: sourceUrl + "users")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        
        var userList = ["Bull", "garbage", "trash"]
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            print(response)
            print(data)
            print(error)
            userList = try! JSONDecoder().decode([String].self, from: data!)
            self.users = userList
            completion(self.users)
        }
        task.resume()
    }
    
    func getMessages(completion:@escaping ([Message])->()){
        print(self.token.token)
        let url = URL(string: sourceUrl + "messages")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        
        var messages = [Message]()
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            print(response)
            print(data)
            print(error)
            messages = try! JSONDecoder().decode([Message].self, from: data!)
            self.messages = messages
            completion(messages)
        }
        task.resume()
        
    }
    
    func postMessage(message: Message, completion:@escaping()->()){
        let url = URL(string: sourceUrl + "messages")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        request.httpMethod = "Post"
        request.httpBody = try! JSONEncoder().encode(message)
        let task = URLSession(configuration: .ephemeral).dataTask(with: request){(data, response, error) in
            print(response)
            print(data)
            print(error)
            completion()
        }
        task.resume()
    }
    
    func postLike(messageID: String, completion:@escaping ()->()){
        let url = URL(string: sourceUrl + "like")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        let like = Like(likedMessageID: messageID)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(like)
        let task = URLSession(configuration: .ephemeral).dataTask(with: request){(data, response, error) in
            print(response)
            print(data)
            print(error)
            completion()
        }
        task.resume()
    }
    
    func getPrivateMessages(completion:@escaping ([PrivateMessage])->()){
        let url = URL(string: sourceUrl + "direct")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        var messages = [PrivateMessage]()
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            print(response)
            print(data)
            print(error)
            messages = try! JSONDecoder().decode([PrivateMessage].self, from: data!)
            print(messages)
            //self.messages = messages
            completion(messages)
        }
        task.resume()
    }
    
    func postPrivateMessage(to: String, message: Message, completion:@escaping ()->()){
        let url = URL(string: sourceUrl + "direct")!
        var request = URLRequest(url: url)
        request.addValue(self.token.token!, forHTTPHeaderField: "token")
        var message = PrivateMessage(to: to, from: self.currentUser, message: message)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(message)
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) {(data, response, error) in
            print(response)
            print(data)
            print(error)
            //self.messages = messages
            completion()
        }
        task.resume()
        
    }
}
