//
//  crypto_detail_viewViewController.swift
//  crypto_watch
//
//  Created by Jack Hansen on 9/29/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import UIKit
import Promises

class crypto_detail_view: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var detailTitle: UITextField!
    @IBOutlet weak var detailPrice: UITextField!
    @IBOutlet weak var detailChange: UITextField!
    @IBOutlet weak var detailVolume: UITextField!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var predictedPriceField: UITextField!
    
    var coin: Coin?
    var pickerData: [Int] = [Int]()
    
    var selectedPrice: Int?
    var reminder: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
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
        
        for i in stride(from: 0, through: 20000, by: 500) {
            self.pickerData.append(i)
        }
        
        let pullCurrencies = PullCurrencies()
        let predictionPromise = pullCurrencies.getPrediction(coin: self.coin!)
        
        predictionPromise.then { data in
            print(data)
            self.predictedPriceField.text = "$\(String(data))"
        }
        
    }
    
    @IBAction func setAlert(_ sender: Any) {
        self.reminder = self.selectedPrice
        
        let alert = UIAlertController(title: "Reminder Set", message: "Price reminder has been set for \(self.reminder ?? 0)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in print("Ok pressed")}))
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
        self.selectedPrice = pickerData[row]
        return String(pickerData[row])
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
