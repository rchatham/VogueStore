//
//  ShopViewController.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/16/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit
import ionicons

class ShopViewController: UIViewController, NavBarCustomizeable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 1. Style navigation bar
        
        let tint = AppDelegate.Static.tint
        
        let leftImage = IonIcons.image(withIcon: ion_chevron_left, iconColor: tint, iconSize: 35, imageSize: CGSize(width: 40, height: 40))
        let leftItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(ShopViewController.goBack(_:)))
        
        let titleLabel = UILabel()
        titleLabel.text = "Shop"
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        titleLabel.textColor = UIColor(red: 83/255, green: 88/255, blue: 95/255, alpha: 1)
        titleLabel.sizeToFit()
        
        let rightImage = IonIcons.image(withIcon: ion_ios_cart, iconColor: tint, iconSize: 40, imageSize: CGSize(width: 40, height: 40))
        let rightItem = UIBarButtonItem(image: rightImage, style: .plain, target: nil, action: nil)
        
        customNavigationBar = styleNavBar(leftItems: [leftItem], titleView: titleLabel, rightItems: [rightItem])
        
        configureItems()
    }

    func goBack(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    
    private var customNavigationBar: UINavigationBar!
    
    private var badgeView: UIView! {
        didSet {
            badgeView.backgroundColor = AppDelegate.Static.tint
            badgeView.layoutIfNeeded()
            badgeView.layer.cornerRadius = badgeView.frame.width/2
            badgeView.clipsToBounds = true
            badgeView.layer.borderColor = UIColor.white.cgColor
            badgeView.layer.borderWidth = 1
        }
    }
    
    private var cartCounter: Int = 0 {
        didSet {
            // update cart indicator
            if cartCounter > 0 {
                
                badgeView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                badgeView.frame.origin = CGPoint(
                    x: customNavigationBar.frame.size.width - 28,
                    y: 16
                )
                
                let badgeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                badgeLabel.text = "\(cartCounter)"
                badgeLabel.textColor = .white
                badgeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
                badgeLabel.textAlignment = .center
                badgeLabel.adjustsFontSizeToFitWidth = true
                
                badgeView.addSubview(badgeLabel)
                
                customNavigationBar.addSubview(badgeView)
            }
        }
    }
    
    private func configureItems() {
        let callback = { [unowned self] in
            self.cartCounter += 1
        }
        
        featuredItem.configure(ItemStyle(itemName: "Magician Hat", price: 39.00, image: UIImage(named: "magician-hat")!, isFeatured: true, callback: callback))
        
        item1.configure(ItemStyle(itemName: "Sneakers A", price: 49.95, image: UIImage(named: "red-shoes")!, isFeatured: false, callback: callback))
        
        item2.configure(ItemStyle(itemName: "Shoes B", price: 79.95, image: UIImage(named: "black-heels")!, isFeatured: false, callback: callback))
        
        item3.configure(ItemStyle(itemName: "Dress A", price: 99.00, image: UIImage(named: "polka-dot-dress")!, isFeatured: false, callback: callback))
        
        item4.configure(ItemStyle(itemName: "Dress B", price: 89.00, image: UIImage(named: "flower-dress")!, isFeatured: false, callback: callback))
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var featuredItem: ItemView!
    @IBOutlet weak var item1: ItemView!
    @IBOutlet weak var item2: ItemView!
    @IBOutlet weak var item3: ItemView!
    @IBOutlet weak var item4: ItemView!

}
