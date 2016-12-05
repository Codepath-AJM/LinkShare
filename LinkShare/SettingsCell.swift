//
//  SettingsCell.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 12/4/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    var settingsIdentifier: SettingsRowIdentifier? {
        didSet {
            titleLabel.text = settingsIdentifier?.rawValue
        }
    }

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
