//
//  crypto_list_controller.swift
//  crypto_watch
//
//  Created by Jack Hansen on 9/29/18.
//  Copyright © 2018 Jack Hansen. All rights reserved.
//

import UIKit
import Promises

class crypto_list_controller: UITableViewController {
    
    var currencies: [Coin]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pullCurrencies = PullCurrencies()
        let promises = pullCurrencies.getCurrencies()
        all(promises).then { coins in
            self.currencies = coins
            self.tableView.reloadData()
        }
        
        tableView.estimatedRowHeight = 50
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crypto_cell", for: indexPath) as! crypto_cell

        // Configure the cell...
        let row = indexPath.row
        cell.cellTitle.text = currencies![row].coinName
        cell.cellPrice.text = String(currencies![row].coinPrice)
        cell.cellChange.text = String(currencies![row].coinChange)
        cell.cellVolume.text = String(currencies![row].coinVolume)

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            
            let detailController = segue.destination as! crypto_detail_view
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let row = indexPath?.row
            detailController.coin = self.currencies![row!]
        }
    }
    

}
