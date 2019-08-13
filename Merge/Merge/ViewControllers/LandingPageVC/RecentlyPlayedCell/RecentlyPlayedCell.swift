//
//  RecentlyPlayedCell.swift
//  Merge
//
//  Created by Bibin Mathew on 7/14/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

protocol RecentlyPlayedCellDelegate: class {
    func likeButtonActionDelegateWithTag(tag:NSInteger)
    func favoriteButtonActionDelegateWithTag(tag:NSInteger)
}

class RecentlyPlayedCell: UICollectionViewCell {
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var singerImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate : RecentlyPlayedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCell(to model:SongHistoryModel) -> () {
        songNameLabel.text = model.title
        timeLabel.text = AlwisalUtility().convertDateInMillisecondsToString(dateInMilliseconds: model.songDate)
         guard let encodedUrlstring =  model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        singerImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
        favoriteButton.isSelected = model.isFavorited
        likeButton.isSelected = model.isLiked
    }
    

    @IBAction func likeBUttonAction(_ sender: UIButton) {
        delegate?.likeButtonActionDelegateWithTag(tag: self.tag)
    }
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        delegate?.favoriteButtonActionDelegateWithTag(tag: self.tag)
    }
    
}
