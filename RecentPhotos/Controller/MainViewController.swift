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
    
    var urlAndTitles = [String: String]()
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
    
    func downloadPhotosArray(urlWithTitle: [String : String]) {
        urlAndTitles = urlWithTitle
//        print("urltitleset")
        DispatchQueue.main.async {
            for item in self.urlAndTitles.keys {
                self.titles.append(item)
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell", for: indexPath)
            cell.textLabel?.text = titles[indexPath.row]
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.loadingEffect.startAnimating()
            return cell
        }
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return titles.count
        } else if section == 1 && isLoadMore {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(titles[indexPath.row])
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.imageUrl = urlAndTitles[titles[indexPath.row]]!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height * 1.2  {
            if !isLoadMore {
                loadNewPhotos()
            }
        }
    }
    
    func loadNewPhotos() {
        isLoadMore = true
        print("Load new Photos")
        DispatchQueue.main.async {
            self.isLoadMore = false
            self.photosModel.downloadPhotos()
        }

    }
    

    
}
