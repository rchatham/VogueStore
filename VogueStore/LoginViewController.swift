//
//  ViewController.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/13/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBAction func tappedLogin(_ sender: UIButton) {
        
        // get current view's frame
        let frame = view.frame
        
        // Add overlay view
        let overlay = UIView(frame: frame)
        overlay.backgroundColor = .black
        overlay.alpha = 0
        view.addSubview(overlay)
        
        // Add authorization instruction view
        let authorizationView = AuthorizationView(frame:
            CGRect(
                x: (frame.width-262)/2,
                y: (frame.height-(314+15)),
                width: 262,
                height: 314
            )
        )
        authorizationView.layer.cornerRadius = 8
        authorizationView.clipsToBounds = true
        authorizationView.frame.origin.y = authorizationView.frame.origin.y + frame.height
        view.addSubview(authorizationView)
        
        
        var success = false
        var error: Error!
        
        Animate(duration: 0.5) {
            // Animate overlay view
            overlay.alpha = 0.8
            
        }.then(duration: 0.5) {
            // Animate authorization instruction view
            authorizationView.frame.origin.y = authorizationView.frame.origin.y - frame.height
            
        }.wait { [unowned self] resume in
            // Check for local authentication with touchID
            self.localAuthentcation { _success, _error in
                
                success = _success
                error = _error
                resume()
            }
            
        }.then(duration: 0.5) {
            // Animate overlay view and authorization instruction view away
            overlay.alpha = 0
            authorizationView.frame.origin.y = authorizationView.frame.origin.y + frame.height
            
        }.then(duration: 0.0) { [unowned self] in
            // Remove overlay and authorization instruction views
            overlay.removeFromSuperview()
            authorizationView.removeFromSuperview()
            
            if success {
                // Present home view controller
                self.performSegue(withIdentifier: "didLogin", sender: nil)
            } else {

                // Present alert if error occured
                let alert = UIAlertController(title: "Authentication error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }.perform()
            
    }

    func localAuthentcation(callback: @escaping (Bool, Error?)->Void) {
        let myContext = LAContext()
        let myLocalizedReasonString = "Please use your TouchID to login"
        
        var authError: NSError? = nil
        
        // Check if can use touch ID to log in
        guard myContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)  else {
            // Could not evaluate policy. Look at authError and present an appropriate message to user
            print("Authentication error: \(authError!.localizedDescription)")
            
            let alert = UIAlertController(title: "Authentication error", message: authError!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.async {
                callback(false, authError)
            }
            return
        }
        myContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { (success, evaluateError) in
            
            DispatchQueue.main.async {
                callback(success, evaluateError)
            }
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton?.layer.borderColor = UIColor.white.cgColor
            loginButton?.layer.borderWidth = 1
        }
    }
    
}

