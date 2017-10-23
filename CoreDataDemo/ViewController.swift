//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Shashikant Jagtap on 21/10/2017.
//  Copyright © 2017 Shashikant Jagtap. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        
        newUser.setValue("Shashikant", forKey: "username")
        newUser.setValue("1234", forKey: "password")
        newUser.setValue("12", forKey: "age")
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Failed saving")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               print(data.value(forKey: "username") as! String)
            }
            
        } catch {
            
            print("Failed")
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

