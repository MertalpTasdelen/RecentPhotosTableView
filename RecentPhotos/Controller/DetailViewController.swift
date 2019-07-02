//
//  DetailViewController.swift
//  RecentPhotos
//
//  Created by Mertalp Taşdelen on 1.07.2019.
//  Copyright © 2019 Mertalp Taşdelen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    var selectedImage = UIImage()
    var imageUrl: String = "nil"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(imageUrl)
        downloadPhoto()
    }
    

    func downloadPhoto(){
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let downloadTask = defaultSession.dataTask(with: URL(string: imageUrl)!) {
            (data, response, error) in
            
            if error != nil {
                print("Error while downloading image from url:")
            }else {
                let imageToReflect = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.image.image = imageToReflect
                }
            }
        }
        downloadTask.resume()
    }
}
