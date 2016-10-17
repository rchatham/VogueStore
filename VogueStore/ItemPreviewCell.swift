//
//  ItemPreviewCell.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/15/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit

class ItemPreviewCell: UICollectionViewCell {

    func configure(_ image: UIImage) {
        imageView?.image = image
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView?.contentMode = .scaleAspectFill
        }
    }
    
}
