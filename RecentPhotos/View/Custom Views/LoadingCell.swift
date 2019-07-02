//
//  LoadingCell.swift
//  RecentPhotos
//
//  Created by Mertalp Taşdelen on 1.07.2019.
//  Copyright © 2019 Mertalp Taşdelen. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var loadingEffect: UIActivityIndicatorView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
