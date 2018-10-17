//
//  user.swift
//  crypto_watch
//
//  Created by Jack Hansen on 10/14/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import Foundation

class User {
    let email: String?
    let authToken: String?
    var signedIn: Bool = false
    
    static var userSingleton: User?
    
    private init(email: String, authToken: String) {
        self.email = email
        self.authToken = authToken
    }
    
    public static func create(email: String, authToken: String) {
        if userSingleton == nil {
            userSingleton = User(email: email, authToken: authToken)
        }
    }
}
