//
//  RoundedView.swift
//  Cumulus
//
//  Created by Felix Hedlund on 2017-09-21.
//  Copyright © 2017 Jayway. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = cornerRadius
    }
}
