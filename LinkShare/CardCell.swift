//
//  CardCell.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/15/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var userImage1: UIImageView!
    @IBOutlet weak var userImage2: UIImageView!
    @IBOutlet weak var userImage3: UIImageView!
    @IBOutlet weak var userImage4: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage1.layer.cornerRadius = 15
        userImage2.layer.cornerRadius = 15
        userImage3.layer.cornerRadius = 15
        userImage4.layer.cornerRadius = 15
        authorImage.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 1
        cardView.layer.shadowOffset = CGSize(width: -0.2, height: 0.2)
        cardView.layer.shadowRadius = 1
        cardView.layer.shadowOpacity = 0.2
        
        let path = UIBezierPath(rect: cardView.bounds)
        cardView.layer.shadowPath = path.cgPath
    }
}
