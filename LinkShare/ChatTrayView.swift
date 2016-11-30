//
//  ChatTrayView.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 11/28/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit

class ChatTrayView: UIView {
    @IBOutlet var contentView: UIView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "ChatTrayView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        // custom initialization logic here
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
