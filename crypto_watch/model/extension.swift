//
//  extension.swift
//  crypto_watch
//
//  Created by Jack Hansen on 10/19/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import Foundation

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
