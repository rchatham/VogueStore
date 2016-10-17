//
//  NavBarCustomizeable.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/14/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit

protocol NavBarCustomizeable {
    func styleNavBar(leftItems: [UIBarButtonItem], titleView: UIView, rightItems:[UIBarButtonItem]) -> UINavigationBar
}

extension NavBarCustomizeable where Self: UIViewController {
    
    func styleNavBar(leftItems: [UIBarButtonItem], titleView: UIView, rightItems:[UIBarButtonItem]) -> UINavigationBar {
        
        self.navigationController?.isNavigationBarHidden = true
        
        let navBar = UINavigationBar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 58))
        navBar.isTranslucent = false
        navBar.shadowImage = UIImage(named: "TransparentPixel")
        navBar.setBackgroundImage(UIImage(named: "Pixel"), for: UIBarMetrics.default)
        
        let onePixelView = UIView(frame: CGRect(x: 14, y: 58, width: 346, height: 1))
        onePixelView.backgroundColor = UIColor(red: 200/255, green: 206/255, blue: 204/255, alpha: 1)
        navBar.addSubview(onePixelView)
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItems = leftItems
        navItem.titleView = titleView
        navItem.rightBarButtonItems = rightItems
        navBar.items = [navItem]        
        
        view.addSubview(navBar)
        
        return navBar
    }
}
