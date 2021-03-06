//
//  sign_in_controller.swift
//  crypto_watch
//
//  Created by Jack Hansen on 9/29/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import UIKit
import GoogleSignIn

class sign_in_controller: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInLabel: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        self.signInButton.style = GIDSignInButtonStyle.standard
        self.signInLabel.sizeToFit()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // _ted object to the new view controller.
    }
}
