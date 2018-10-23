//
//  AppDelegate.swift
//  crypto_watch
//
//  Created by Jack Hansen on 9/29/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleSignIn
import Alamofire
import Promises

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            User.create(email: user.profile.email, authToken: user.authentication.idToken)
            let user = User.userSingleton
            let authenticateUser = AuthenticateUser(user: user!)
            authenticateUser.signIn(transitionWindow: window!)
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User Logged out")
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "1076348502483-slk0eiuptrf1hiei9goi7jmt8m013v7a.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        let generalCategory = UNNotificationCategory(identifier: "GENERAL",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
        // Register the category.
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([generalCategory])
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if let receivedError = error {
                print(receivedError)
            } else {
                print("Notifications authorized")
            }
        }
        
        // 6 hours
        UIApplication.shared.setMinimumBackgroundFetchInterval(6 * (60 * 60))
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication,
                              performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("In performFetch")
        self.getCurrencyUpdates()
    }
    
    func getCurrencyUpdates() {
        var coins: [Coin]?
        var reminders: [String : Double]?
        let pullCurrencies = PullCurrencies()
        
        let currencyPromises = pullCurrencies.getCurrencies()
        all(currencyPromises).then { returnedCoins in
            coins = returnedCoins
            
            let reminderCalls = ReminderCalls()
            let reminderPromise = reminderCalls.getReminders()
            reminderPromise.then { returnedReminders in
                reminders = returnedReminders
                
                self.comparePrices(coins: coins!, reminders: reminders!)
            }
        }
    }
    
    func comparePrices(coins: [Coin], reminders: Dictionary<String, Double>) {
        var notificationList: [String : Double] = [:]
        
        for reminder in reminders {
            let reminderSymbol = reminder.key
            
            for coin in coins {
                if coin.coinSymbol == reminderSymbol {
                    let adjustedPriceHigh = coin.coinPrice + (coin.coinPrice * 0.05) // Bump up the price 5%
                    let adjustedPriceLow = coin.coinPrice - (coin.coinPrice * 0.05)  // reduce the price 5%
                    
                    // add the reminder to notificationList if its between the high and low value
                    if adjustedPriceLow...adjustedPriceHigh ~= reminder.value {
                        notificationList[coin.coinName] = coin.coinPrice
                    }
                    break
                }
            }
        }
        
        createReminderNotification(notifications: notificationList)
    }
    
    func createReminderNotification(notifications: [String : Double]) {
        var notificationBody: String = ""
        
        for (key, value) in notifications {
            notificationBody.append(contentsOf: "\(key): \(value)\n")
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = NSString.localizedUserNotificationString(forKey: "Crypto Reminder", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: notificationBody, arguments: nil)
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (30), repeats: false)
        
        let reminderRequest = UNNotificationRequest(identifier: "CryptoReminder", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(reminderRequest, withCompletionHandler: { (error: Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

