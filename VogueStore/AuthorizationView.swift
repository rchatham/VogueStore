//
//  AuthorizationView.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/14/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit

class AuthorizationView: UIView {
    
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
        let bundle = Bundle(for: AuthorizationView.self)
        let nib = UINib(nibName: "AuthorizationView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
}
