//
//  AlternatePreviewCell.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/15/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit
import ionicons

struct AlternatePreviewCellStyle {
    let image: UIImage
    let primaryText: String
    let secondaryText: String?
    let actionText: String
}

class AlternatePreviewCell: UICollectionViewCell {
    
    func configure(withStyle style: AlternatePreviewCellStyle) {
        imageView?.image = style.image
        primaryLabel?.text = style.primaryText
        secondaryLabel?.text = style.secondaryText
        actionLabel?.text = style.actionText
        
        if style.secondaryText == nil {
            secondaryLabel?.frame.size.height = 0
            topLabelConstraint?.constant = 20
            bottomLabelConstraint?.constant = 20
        } else {
            secondaryLabel?.sizeToFit()
            topLabelConstraint?.constant = 12
            bottomLabelConstraint?.constant = 12
        }
        contentView.bringSubview(toFront: actionView)
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var topLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var infoView: UIView! {
        didSet {
            infoView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }
    }
    
}
