//
//  GroceriesListTableViewController.swift
//  GAGroceriesList
//
//  Created by Courtney Osborne on 8/9/16.
//  Copyright © 2016 Courtney Osborne. All rights reserved.
//

import UIKit
import CoreData

class GroceriesListTableViewController: UITableViewController {

    let cellId = "reuseIdentifier"
    
    // Properties
    var objects = [NSManagedObject]()
    var quantity: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        fetchRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchRequest() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "EntityItems")
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            objects = results as! [NSManagedObject]
        } catch {
            print("Error: Failed request")
        }
    }
    
    @IBAction func addItems(sender: UIBarButtonItem) {
        
        
        // For user to enter information
        let alertController = UIAlertController(title: "Add Grocery", message: "This is the item", preferredStyle: .Alert)
        
        // Action on top of the Controller
        let alertAction = UIAlertAction(title: "Add Item", style: .Default) { (action) in
            
            let textfield = alertController.textFields![0]
            let detailTextField = alertController.textFields![1]
        
            self.saveItem(textfield.text!, detail: detailTextField.text!)
            self.tableView.reloadData()
        }
        
        alertController.addAction(alertAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Grocery item"
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (detailTextField) in
            detailTextField.placeholder = "Short description"
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (quantityTextField) in
            quantityTextField.placeholder = "quantity"
             self.quantity = quantityTextField.text
            print(self.quantity)
            
        }
        
        // Present the AlertController
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    // Saving users items into CoreData
    func saveItem(items: String, detail: String) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("EntityItems", inManagedObjectContext: managedObjectContext)
        
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        // Writes to items and details of item 
        item.setValue(items, forKey: "list")
        item.setValue(detail, forKey: "detail")

        do {
            try managedObjectContext.save()

            objects.append(item)
            
        } catch {
            
            print("Error: Could not save item!")
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        
        // Add the objects to IndexPath
        let list = objects[indexPath.row]
        
        // Get objects from NSManagedObjects
        cell.textLabel?.text =  list.valueForKey("list") as? String
        cell.detailTextLabel?.text = list.valueForKey("detail") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.accessoryType == .Checkmark {
            cell!.accessoryType = .None
        } else {
            cell!.accessoryType = .Checkmark
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
            managedObjectContext.deleteObject(objects.removeAtIndex(indexPath.row))
            
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
        
        let destination = segue.destinationViewController as? DetailedGroceriesViewController
        
        let list = objects[indexPath!.row]
        destination?.item = list.valueForKey("list") as? String
        destination?.details = list.valueForKey("info") as? String
        destination?.amount = self.quantity
    }

}
