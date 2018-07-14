//
//  RecentlyPlayedCell.swift
//  Merge
//
//  Created by Bibin Mathew on 7/14/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class RecentlyPlayedCell: UICollectionViewCell {
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var singerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    @IBAction func likeBUttonAction(_ sender: UIButton) {
    }
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
    }
    
}
