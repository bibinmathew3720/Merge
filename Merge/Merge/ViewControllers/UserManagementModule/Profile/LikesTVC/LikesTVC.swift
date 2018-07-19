//
//  LikesTVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/19/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class LikesTVC: UITableViewCell {

    @IBOutlet weak var subHeadinglabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFavoriteDetails(favoriteItem:FavoritesModel){
        headingLabel.text = favoriteItem.title
        subHeadinglabel.text = ""
        
    }
    func setLikeDetails(likeItem:LikesModel){
        headingLabel.text = likeItem.title
        subHeadinglabel.text = ""
        
    }

    @IBAction func closeButtonAction(_ sender: UIButton) {
    }
}
