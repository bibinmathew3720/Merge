//
//  MenuProfileCell.swift
//  Merge
//
//  Created by Bibin Mathew on 7/15/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class MenuProfileCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func setUserDetails(){
        if let nameString = UserDefaults.standard.value(forKey: Constant.VariableNames.userName) {
            nameLabel.text = nameString as! String
        }
    }

}
