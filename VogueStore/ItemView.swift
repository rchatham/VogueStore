//
//  ItemView.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/16/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit

struct ItemStyle {
    let itemName: String
    let price: Double
    let image: UIImage
    let isFeatured: Bool
    let callback: (Void)->Void
}

class ItemView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadView()
    }
    
    func loadView() {
        let bundle = Bundle(for: ItemView.self)
        let nib = UINib(nibName: "ItemView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func configure(_ style: ItemStyle) {
        let prefix = style.isFeatured ? "Featured Item: " : ""
        itemNameLabel?.text = prefix + style.itemName
        
        let formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        formatter.currencyDecimalSeparator = "."
        formatter.currencyGroupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.alwaysShowsDecimalSeparator = true
        formatter.groupingSize = 3
        formatter.numberStyle = .currency
        
        priceLabel?.text = formatter.string(from: NSNumber(value: style.price))
        
        itemImageView?.image = style.image
        
        callback = style.callback
        button?.addTarget(self, action: #selector(ItemView.buttonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        if !style.isFeatured {
            saleImageView?.isHidden = true
            itemImageView?.layer.borderColor = UIColor(red: 166/255, green: 170/255, blue: 169/255, alpha: 1).cgColor
            itemImageView?.layer.borderWidth = 1
        } else {
            saleImageView?.isHidden = false
            itemImageView?.layer.borderWidth = 0
        }
        
        backgroundColor = .white
    }
    
    func buttonPressed(_ sender: UIButton) {
        callback()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            itemImageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var saleImageView: UIImageView!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.shadowOffset = CGSize(width: -1, height: 1)
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 2.0
        }
    }
    
    // MARK: - Private
    
    private var callback: (Void)->Void = {_ in}
}
