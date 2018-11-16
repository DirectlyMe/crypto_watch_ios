//
//  reminder_calls.swift
//  crypto_watch
//
//  Created by Jack Hansen on 10/21/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import Foundation
import Alamofire
import Promises
import SwiftyJSON

class ReminderCalls {
    let url = "http://\(Config.serverIP)/user"
    
    func postReminder(coin: Coin, price: Double) {
        let params = ["currency": coin.coinSymbol, "priceReminder": price] as Parameters
        
        Alamofire.request("\(self.url)/set-price-reminder", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON(completionHandler:
            { data in
                print(data)
            })
    }
    
    
    func getReminders() -> Promise<Dictionary<String, Double>> {
        return Promise<Dictionary<String, Double>>
            { fulfill, reject in
                Alamofire.request("\(self.url)/get-price-reminders", method: .get)
                    .responseJSON(completionHandler:
                    { response in
                        if let data = response.result.value {
                           
                            let dict = data as! Dictionary<String, Double>
                            print(dict)
                            fulfill(dict)
                        }
                    }
                )
            }
    }
}
