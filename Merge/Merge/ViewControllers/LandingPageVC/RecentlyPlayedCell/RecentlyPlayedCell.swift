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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCell(to model:SongHistoryModel) -> () {
        songNameLabel.text = model.title
        timeLabel.text = AlwisalUtility().convertDateInMillisecondsToString(dateInMilliseconds: model.songDate)
        singerImageView.sd_setImage(with: URL(string: model.imagePath), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
        favoriteButton.isSelected = model.isFavorited
        likeButton.isSelected = model.isLiked
    }
    

    @IBAction func likeBUttonAction(_ sender: UIButton) {
    }
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
    }
    
}
