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
    // MARK: Outlets
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var fetchButton: UIButton!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var enterPassword: UITextField!
    @IBOutlet weak var enterName: UITextField!

    // MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchButton.isEnabled = false
        submitButton.isEnabled = false

        [enterPassword, enterName, dobPicker].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Field Actions

    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let name = enterName.text, !name.isEmpty,
            let password = enterPassword.text, !password.isEmpty
        else {
            submitButton.isEnabled = false
            return
        }
        submitButton.isEnabled = true

    }

    @IBAction func submitAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)

        newUser.setValue(enterName.text, forKey: "username")
        newUser.setValue(enterPassword.text, forKey: "password")
        let date = Date()
        let calendar = Calendar.current
        _ = calendar.component(.hour, from: date)
        _ = calendar.component(.minute, from: date)

        let age = calendar.dateComponents([.year], from: date, to: dobPicker.date)
        print("age in years =\(String(describing: abs(age.year!)))")
        newUser.setValue(String(abs(age.year!)), forKey: "age")
        do {
            try context.save()
            fetchButton.isEnabled = true
        } catch {
            print("Failed saving")
        }
    }

    @IBAction func clearDataBase(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Users")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = appDelegate.persistentContainer.viewContext

        do {
            try context.execute(deleteRequest)
            clearButton.isEnabled = false
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
    }
    @IBAction func fetchAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                nameLabel.text = (data.value(forKey: "username") as! String)
                passwordLabel.text = (data.value(forKey: "password") as! String)
                ageLabel.text = (data.value(forKey: "age") as! String)
            }
        } catch {
            print("Failed")
        }
    }
}

