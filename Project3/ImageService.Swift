//
//  ImageService.swift
//  Project3
//
//  Created by Michael Bolot on 11/18/17.
//  Copyright © 2017 Michael Bolot. All rights reserved.
//

import UIKit

class imageService{
    var cache:[URL:UIImage] = [:]


    func imageForURL(url: URL?, completion: @escaping (UIImage?) -> ()){
        guard let url = url else { completion(nil); return}
        if let image = cache[url]{
            completion(image)
            return
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data,response,error) in
            ///
            guard let data = data else{completion(nil); return}
            if error != nil{ completion(nil); return}
            let image = UIImage(data: data)
            if let img = image{
                self.cache[url] = img
            }
            
            completion(image)
            return
        }
        task.resume()
    }
}
