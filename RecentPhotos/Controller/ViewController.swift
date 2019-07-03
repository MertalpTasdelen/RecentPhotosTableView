//
//  ViewController.swift
//  RecentPhotos
//
//  Created by Mertalp Taşdelen on 28.06.2019.
//  Copyright © 2019 Mertalp Taşdelen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, PhotosDownloadDelegate {
    
    func downloadPhotosArray(arrayOf photos: [Photos]) {
        //
    }
    
    
    var isLoadMore = false
    var imageArray = [UIImage]()
    var images = [String]()
    let photosModel = Photos()
    var validationImageUrl: String?
    var photoArray = [Photos]()
    
    
    //new aproch
    var urlAndTitle = [String:String]()
    var titles = [String]()
    
    
    var number = 1
    
    let params: [String: String] = ["api_key": "04be207f74301107ecb9ab3ff64a0599", "extras": "date_upload", "page": "1" , "per_page": "20"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent Photos"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        tableView.delegate = self
        
//        tableView.reloadData()
        
        photosModel.delegate = self
        photosModel.downloadPhotos()
    
    }
    
    func downloadPhotosArray(urlWithTitle: [String : String]) {
        urlAndTitle = urlWithTitle
        for item in urlAndTitle.values{
            titles.append(item)
        }
        print("titles are ready")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return titles.count
        }else if section == 1 && isLoadMore {
            return titles.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            print("Trying to load cell info")
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
            cell.textLabel?.text = "Item \( titles[indexPath.row])"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.loadingEffect.startAnimating()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.selectedImage = imageArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//   burada bir sorun var
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoadMore{

            }
        }
    }
    
    func loadNewPhotos() {
        isLoadMore = true
        print("20 new photo")
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.async {
            self.isLoadMore = false
            self.photosModel.downloadPhotos()
            self.tableView.reloadData()
        }
        
    }
    

    
//    func downloadPhotosArray(urlWithTitle: urlAndTitle) {
//
//        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
//
//        for imageURL in images{
//            validationImageUrl = imageURL
//
//            let imageDownloandTask = defaultSession.dataTask(with: URL(string: imageURL)!) {
//                (data, response, error) in
//                if error != nil {
//                    print(error!)
//                }else {
//                    print(imageURL)
//                    let image = UIImage(data: data!)
//                    DispatchQueue.main.async {
//                        //                        if self.validationImageUrl == imageURL {
//                        //                        }
//                        self.imageArray.append(image!)
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//            imageDownloandTask.resume()
//        }
//    }
    
}


