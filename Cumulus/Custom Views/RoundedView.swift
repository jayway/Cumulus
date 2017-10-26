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
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        self.layer.cornerRadius = cornerRadius
    }
}
