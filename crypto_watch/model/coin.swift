//
//  coin.swift
//  crypto_watch
//
//  Created by Jack Hansen on 9/29/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import Foundation

class Coin {
    
    let coinName: String
    let coinPrice: Double
    let coinVolume: Double
    let coinChange: Double
    
    init(name: String, price: Double, volume: Double, change: Double) {
        coinName = name
        coinPrice = price
        coinVolume = volume
        coinChange = change
    }
    
    
}
