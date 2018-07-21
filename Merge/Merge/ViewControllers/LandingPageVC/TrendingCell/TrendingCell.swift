//
//  TrendingCell.swift
//  Merge
//
//  Created by Bibin Mathew on 7/14/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class TrendingCell: UICollectionViewCell {
    @IBOutlet weak var singerImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    func setCell(to model:NewsModel) -> () {
        songNameLabel.text = model.title
       // dateLabel.text = AlwisalUtility().convertDateWithTToString(dateString: model.songDate)
        singerImageView.sd_setImage(with: URL(string: model.imagePath), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
    }
    
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
    }
}
