//
//  crypto_detail_viewViewController.swift
//  crypto_watch
//
//  Created by Jack Hansen on 9/29/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import UIKit
import Promises
import Alamofire

class crypto_detail_view: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var detailTitle: UITextField!
    @IBOutlet weak var detailPrice: UITextField!
    @IBOutlet weak var detailChange: UITextField!
    @IBOutlet weak var detailVolume: UITextField!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var predictedPriceField: UITextField!
    
    var coin: Coin?
    var pickerData: [Double] = [Double]()
    
    var selectedPrice: Double?
    var reminder: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertButton.layer.cornerRadius = 20
        alertButton.clipsToBounds = true
        
        navigationController?.isNavigationBarHidden = false
        
        if let passedCoin = self.coin {
            detailTitle.text = passedCoin.coinName
            detailPrice.text = "$\(String(passedCoin.coinPrice))"
            detailChange.text = String(passedCoin.coinChange)
            detailVolume.text = String(passedCoin.coinVolume)
        }
        
        self.pricePicker.delegate = self
        self.pricePicker.dataSource = self
        
        var top: Double
        var step: Double
        var places: Int
        
        switch coin?.coinSymbol {
        case "BTC":
            top = 20000
            step = 200
            places = 0
        case "ETH":
            top = 1500
            step = 50
            places = 0
        case "LTC":
            top = 500
            step = 10
            places = 0
        case "XRP":
            top = 3.00
            step = 0.05
            places = 2
        default:
            top = 0
            step = 0
            places = 0
        }
        
        for i in stride(from: 0, through: top, by: step) {
            let v = i.truncate(places: places)
            self.pickerData.append(v)
        }
        
        let pullCurrencies = PullCurrencies()
        let predictionPromise = pullCurrencies.getPrediction(coin: self.coin!)
        
        predictionPromise.then { data in
            self.predictedPriceField.text = "$\(String(data))"
        }
        
    }
    
    @IBAction func setAlert(_ sender: Any) {
        self.reminder = self.selectedPrice
        
        let alert = UIAlertController(title: "Price Reminder", message: "Set price reminder for \(self.reminder ?? 0)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:
            { _ in
                let reminderCalls = ReminderCalls()
                reminderCalls.postReminder(coin: self.coin!, price: self.reminder!)
            }
        ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in print("Cancel pressed")}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPrice = pickerData[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
