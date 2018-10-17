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
    let url: String = "http://192.168.1.120:8080"
    
    
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
            Alamofire.request("\(self.url)/currency/get-currency/\(coin)").responseJSON { response in
                if let result = response.result.value {
                    let json = JSON(result)
                    
                    let name = json[coin]["name"].string as String?
                    let change = json[coin]["quote"]["USD"]["percent_change_24h"].double as Double?
                    let volume = json[coin]["quote"]["USD"]["volume_24h"].double as Double?
                    let price = json[coin]["quote"]["USD"]["price"].double as Double?
                    
                    let pulledCoin = Coin(name: name!, price: price!, volume: volume!, change: change!);
                    fulfill(pulledCoin)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Couldn't no pull currencies, the server may be down, or we just can't connect.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dang it!", style: .destructive, handler: { _ in print("Ok pressed")}))
                    
                    var rootVC = UIApplication.shared.keyWindow?.rootViewController
                    if let navigationController = rootVC as? UINavigationController {
                        rootVC = navigationController.viewControllers.first
                        rootVC?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    public func getPrediction(coin: Coin) -> Promise<Double> {
        return Promise<Double> { fulfill, reject in
            Alamofire.request("\(self.url)/predict/get-predcition\(coin.coinName)")
            .responseJSON
            { response in
                    
                    if let result = response.result.value {
                        let json = JSON(result)
                        
                        
                    }
            }
        }
    }
}
