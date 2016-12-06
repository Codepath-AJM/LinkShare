//
//  LinkCell.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/15/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit

class LinkCell: UITableViewCell {
    
    var link: (link: Link, bookmarked: Bool)? {
        didSet {
            titleLabel.text = link?.link.title
            if let commentsCount = link?.link.comments.count {
                commentsLabel.text = "\(commentsCount)"
            }
            
            let bookmarkImg = (link?.bookmarked)! ? #imageLiteral(resourceName: "bookmark-filled") : #imageLiteral(resourceName: "bookmark-outline")
            bookmarkButton.setImage(bookmarkImg, for: .normal)
        }
    }
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBAction func bookmark() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 2
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
    }
}
