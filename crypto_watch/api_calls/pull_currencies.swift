//
//  pull_currencies.swift
//  crypto_watch
//
//  Created by Jack Hansen on 9/29/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Promises

class PullCurrencies {
    
    var pulledCurrencies: [Coin]?
    let coins: [String] = ["BTC", "LTC", "XRP", "ETH"]
    let url: String = "http://192.168.1.120:8080/currency/get-currency/"
    
    public init() {
        self.pulledCurrencies = []
    }
    
    public func getCurrencies() -> [Promise<Coin>] {
        var promises: [Promise<Coin>] = []
        
        for coin in self.coins {
            let promise = getCurrency(coin: coin)
            promises.append(promise)
        }
        
        return promises
    }
    
    public func getCurrency(coin: String) -> Promise<Coin> {
        return Promise<Coin> { fulfill, reject in
            Alamofire.request("\(self.url)\(coin)").responseJSON { response in
                if let result = response.result.value {
                    print("Json: \(result)")
                    let json = JSON(result)
                    print(json)
                    
                    let name = json[coin]["name"].string as String?
                    let change = json[coin]["quote"]["USD"]["percent_change_24h"].double as Double?
                    let volume = json[coin]["quote"]["USD"]["volume_24h"].double as Double?
                    let price = json[coin]["quote"]["USD"]["price"].double as Double?
                    
                    let pulledCoin = Coin(name: name!, price: price!, volume: volume!, change: change!);
                    fulfill(pulledCoin)
                } else {
                    reject("Couldn't pull" as! Error)
                }
            }
        }
    }
}
