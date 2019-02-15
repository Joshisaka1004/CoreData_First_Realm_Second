//
//  DetailVC.swift
//  CoreData_First_Realm_Second
//
//  Created by Joachim Vetter on 14.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class DetailVC: UITableViewController {

    let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let myContext2 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetching2 = NSFetchRequest<Task>(entityName: "Task")
    
    var myTasks = [Task]()
    
    var selectedTask: Menue? {
        didSet {
            loadTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = myTasks[indexPath.row].name!
        return cell
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var finalTextField = UITextField() // Ein UITextField wird als Variable initialisiert, die jeder Methode innerhalb der IB-Action zur Verfügung steht; in der "addTextField-Methode" unten wird das Textfeld des Alert-ViewControllers dieser Variablen zugewiesen, damit die UIAlertAction-Methode auf dieses zugreifen kann!
        
        let myAlertVC = UIAlertController(title: "Add Task", message: "whatever you need or want to do", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK!", style: .default) { (action) in
            let myNewItem = Task(context: self.myContext2)
            myNewItem.name = finalTextField.text!
            myNewItem.parent = self.selectedTask
            self.myTasks.append(myNewItem)
            self.saveTasks()
        }
        
        myAlertVC.addAction(myAction)
        myAlertVC.addTextField { (myTextField) in
            finalTextField = myTextField
        }
        present(myAlertVC, animated: true, completion: nil)
    }
    
    func loadTasks(myRequest: NSFetchRequest<Task> = Task.fetchRequest(), mySecondPredicate: NSPredicate? = nil) {
        
        let myFirstPredicate = NSPredicate(format: "parent.items MATCHES %@", selectedTask!.items!)
        
        if let additionalPredicate = mySecondPredicate {
            let myCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [myFirstPredicate, additionalPredicate])
            myRequest.predicate = myCompound
        } else {
            myRequest.predicate = myFirstPredicate
        }
        
        do {
            myTasks = try myContext2.fetch(myRequest)
        }
        catch {
            print("\(error)")
        }
        self.tableView.reloadData()
    }
    
    func saveTasks() {
        do {
            try myContext2.save()
        }
        catch {
            print("\(error)")
        }
        self.tableView.reloadData()
    }
}

extension DetailVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchPredicate = NSPredicate(format: "name CONTAINS [cd] %@", searchBar.text!)
        fetching2.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadTasks(myRequest: fetching2, mySecondPredicate: searchPredicate)
    }
}
