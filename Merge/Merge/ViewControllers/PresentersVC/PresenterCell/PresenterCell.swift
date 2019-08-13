//
//  PresenterCell.swift
//  Merge
//
//  Created by Bibin Mathew on 7/14/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

protocol PresentercCollectionCellDelegate: class {
    func backButtonActionDelegateWithTag(tag:NSInteger)
    func twitterButtonActionDelegateWithTag(tag:NSInteger)
    func fbButtonActionDelegateWithTag(tag:NSInteger)
}

class PresenterCell: UICollectionViewCell {
    @IBOutlet weak var presenterImageView: UIImageView!
    @IBOutlet weak var presenterNameLabel: UILabel!
    @IBOutlet weak var presenterDesigLabel: UILabel!
    weak var delegate : PresentercCollectionCellDelegate?
    func setPresenterCell(to model:PresenterModel) -> () {
        presenterNameLabel.text = model.title
        presenterDesigLabel.text = model.content
        guard let encodedUrlstring =  model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func setNewsCell(model:NewsModel)->(){
        presenterNameLabel.text = model.title
        presenterDesigLabel.text = model.content
        guard let encodedUrlstring =  model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func setArticleCell(model:ArticlesModel)->(){
        presenterNameLabel.text = model.title
        presenterDesigLabel.text = model.content
        guard let encodedUrlstring =  model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func setEventsCell(model:EventsModel)->(){
        presenterNameLabel.text = model.title
        presenterDesigLabel.text = model.content
        guard let encodedUrlstring =  model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func setshowsCell(model:ShowsModel)->(){
        presenterNameLabel.text = model.title
        presenterDesigLabel.text = model.content
        guard let encodedUrlstring =  model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        delegate?.twitterButtonActionDelegateWithTag(tag: self.tag)
    }
    
    @IBAction func facebookButtonAction(_ sender: UIButton) {
        delegate?.fbButtonActionDelegateWithTag(tag: self.tag)
    }
    
    @IBAction func detailPageButtonAction(_ sender: UIButton) {
        delegate?.backButtonActionDelegateWithTag(tag: self.tag)
    }
}
