//
//  ViewController.swift
//  CoreDataDemo1
//
//  Created by Meenal Kewat on 6/3/19.
//  Copyright © 2019 Meenal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //1
        let foodItem = foodItems[indexPath.row]
        
        //2
        let foodType = foodItem.type
        cell.textLabel?.text = foodType
        
        //3
        let foodDate = foodItem.added
        let dateForematter = DateFormatter()
        dateForematter.dateFormat = "MMMM d yyyy, hh:mm"
        
        cell.detailTextLabel?.text = dateForematter.string(from: foodDate!)
        
        
        //4
        if foodType == "Fruit"{
            cell.imageView?.image = UIImage(named: "Apple")
        }else{
            cell.imageView?.image = UIImage(named: "Salad")
        }
        return cell
    }
    
    
    
    @IBOutlet weak var tableview: UITableView!
    var foodItems = [Food]()
    //1 create managedContex
    var managedContext:NSManagedObjectContext!
    
    //2 create appdelegate reference
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //3 initialize here managedContext
        managedContext = appDelegate?.persistentContainer.viewContext
        
        loadData()
    }
    
    func loadData(){
        //1
        let foodRequest:NSFetchRequest<Food> = Food.fetchRequest()
        //2
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: false)
        foodRequest.sortDescriptors = [sortDescriptor]
        //3
        do{
            foodItems = try managedContext.fetch(foodRequest)
        } catch let error as NSError {
            print("Could not Load data. \(error), \(error.userInfo)")
        }
        //4
        self.tableview.reloadData()
    }

    @IBAction func addFruitAndVegitable(_ sender: UIButton) {
        //1
        
        let foodItem = Food(context: managedContext)
        //2
        foodItem.added = NSDate() as Date
        //3
        if sender.tag == 0{
            foodItem.type = "Fruit"
        } else{
            foodItem.type = "Vegetable"
        }
        
        //4
        appDelegate?.saveContext()
        //5
        loadData()
    }
    
   
    
}

