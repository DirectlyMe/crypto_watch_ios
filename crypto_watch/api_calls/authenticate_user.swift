//
//  authenticate_user.swift
//  crypto_watch
//
//  Created by Jack Hansen on 10/14/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import Foundation
import Alamofire
import Promises

class AuthenticateUser {
    let user: User?
    
    init(user: User) {
        self.user = user
    }
    
    public func signIn(transitionWindow: UIWindow? = nil) {
        let email = self.user!.email
        let authToken = self.user!.authToken
        
        let params = ["tokenID": authToken, "username": email]
        
        Alamofire.request("http://\(Config.serverIP)/auth/signIn", method: .post, parameters: params as Parameters, encoding: JSONEncoding.default).responseJSON
        { response in
            if response.result.error == nil {
                self.user?.signedIn = true
                
                if let window = transitionWindow {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    if let listVC = sb.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController {
                        window.rootViewController = listVC
                    } else {
                        print("Something went wrong")
                    }
                }
            } else {
                self.user?.signedIn = false
            }
        }
    }
}
