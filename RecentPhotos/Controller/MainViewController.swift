//
//  MainViewController.swift
//  RecentPhotos
//
//  Created by Mertalp Taşdelen on 1.07.2019.
//  Copyright © 2019 Mertalp Taşdelen. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UITableViewController, PhotosDownloadDelegate {
    
    var photosModel = Photos()
    
    var photoArray = [Photos]()
    var titles = [String]()
    
    var titleCounter = 1
    var isLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadNib, forCellReuseIdentifier: "loadingCell")
        
        navigationItem.title = "Recent Photos"
        photosModel.delegate = self
        photosModel.downloadPhotos()
        
    }
    
    func downloadPhotosArray(arrayOf photos: [Photos]) {
        photoArray = photos
        DispatchQueue.main.async {
            self.photoArray.sort(by: {$0.uploadedDay > $1.uploadedDay})
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell", for: indexPath)
            cell.textLabel?.text = photoArray[indexPath.row].title
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.loadingEffect.startAnimating()
            return cell
        }
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
//            print(photoArray.count)
            return photoArray.count
        } else if section == 1 && isLoadMore {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(titles[indexPath.row])
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let url = photoArray[indexPath.row].getPhotoSourceURL(photo: photoArray[indexPath.row])
        vc.imageUrl = url
        vc.dateUpload = photoArray[indexPath.row].uploadedDay
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadNewPhotos() {
        isLoadMore = true
        print("Download new 20 photos")
        DispatchQueue.main.async{
            self.photosModel.downloadPhotos()
            self.isLoadMore = false
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = photoArray.count - 5
        if indexPath.row == lastElement {
            print(photoArray.count)
            loadNewPhotos()
        }
    }
    
    
    
}


