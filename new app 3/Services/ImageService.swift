//
//  ImageService.swift
//  new app 3
//
//  Created by William Hinson on 11/28/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, url, error in
            var downloadedImage:UIImage?
            
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        
        dataTask.resume()
    }
    
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
