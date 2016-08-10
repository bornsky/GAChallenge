//
//  DetailedGroceriesViewController.swift
//  GAGroceriesList
//
//  Created by Courtney Osborne on 8/9/16.
//  Copyright © 2016 Courtney Osborne. All rights reserved.
//

import UIKit

class DetailedGroceriesViewController: UIViewController {
    
    var item: String?
    var details: String?
    var amount: String?
    
    @IBOutlet weak var shoppingList: UILabel!
    @IBOutlet weak var groceryDetails: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shoppingList.text = item
        self.groceryDetails.text = details
        self.quantity.text = amount
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}