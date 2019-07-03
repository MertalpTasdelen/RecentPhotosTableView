//
//  Photos.swift
//  RecentPhotos
//
//  Created by Mertalp Taşdelen on 30.06.2019.
//  Copyright © 2019 Mertalp Taşdelen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol PhotosDownloadDelegate {
    func downloadPhotosArray(arrayOf photos: [Photos])
}

class Photos {
    
    var titleCounter = 1
    var pageCounter = 1
    
    var delegate: PhotosDownloadDelegate?
    var photoBulk = [Photos]()
    
    var imageUrlArray = [String]()
    var urlTitle = [String:String]()
    
    var farmId: String = "1"
    var serverId: String = "2"
    var photoId: String = "1418878"
    var secretKey: String = "1e92283336"
    var uploadedDay: String = "1561919846"
    var title: String = "Good Photo For User"
    var photoSize: String = "z"
    
    func getPhotoSourceURL(photo: Photos) -> String{
        return  "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secretKey)_\(photoSize).jpg"
    }
    
    func downloadPhotos() {
            let baseURL = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=04be207f74301107ecb9ab3ff64a0599&extras=date_upload&page=\(pageCounter)&per_page=20&format=json&nojsoncallback=1"
        pageCounter += 1
//        print(baseURL)
    
        Alamofire.request(baseURL, method: .get).responseJSON{
            response in
            if response.result.isSuccess {
                let photoJSON: JSON = JSON(response.result.value!)
                self.decodeJson(json: photoJSON)
            }else {
                
            }
        }
        
    }
    
    func decodeJson(json: JSON){
        
        let status = json["stat"].stringValue
        if status == "fail" {
            print(json["message"].stringValue)
        }else {
            let serverResponse = json["photos"]["photo"]
            
            for index in 0..<20{
                let newPhoto = Photos()
                newPhoto.farmId = serverResponse[index]["farm"].stringValue
                newPhoto.serverId = serverResponse[index]["server"].stringValue
                newPhoto.photoId = serverResponse[index]["id"].stringValue
                newPhoto.secretKey = serverResponse[index]["secret"].stringValue
                newPhoto.uploadedDay = serverResponse[index]["dateupload"].stringValue
                newPhoto.title = serverResponse[index]["title"].stringValue
                
                if newPhoto.title == "" { newPhoto.title = "There is no title \(titleCounter)"
                    titleCounter += 1
                }
                photoBulk.append(newPhoto)
                urlTitle["\(newPhoto.title)"] = "\(newPhoto.getPhotoSourceURL(photo: newPhoto))"
                
            }
            
        }
        DispatchQueue.main.async {
            self.delegate?.downloadPhotosArray(arrayOf: self.photoBulk)
        }
      
    }
    
//    func downloadImages(url: String) -> UIImage{
//        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
//        var userImage = UIImage()
//
//        let imageTask = defaultSession.dataTask(with: URL(string: url)!){
//            (data, response, error) in
//
//            if error != nil {
//                print(error!)
//            }else {
//                userImage = UIImage(data: data!)!
//            }
//        }
//        imageTask.resume()
//        return userImage
//    }
}


