//
//  ViewController.swift
//  CoreData_First_Realm_Second
//
//  Created by Joachim Vetter on 14.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData

class MenueVC: UITableViewController {

    let myAppPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Pfad zur App im Dateimanager des Geräts
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // der Context des Persistent Containers von Core Data, nur der Context ist direkt ansprechbar, nicht der Container selbst!
    
    let fetching = NSFetchRequest<Menue>(entityName: "Menue")
    
    var myMenue = [Menue]() // Array aus Instanzen vom Datentyp der Entity (= Klasse) "Menue" von Core Data (deklariert in der Datei ...xcdatamodelID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMenue.count // Anzahl der Tabellenzeilen entspricht der Anzahl der Instanzen unserer CoreData-Entity "Menue"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = myMenue[indexPath.row].items! //"items" ist das (einzige) Attribut (= Eigenschaft/Property) der Entity "Menue", welches als String den Haupttext in einer Zeile darstellt und sozusagen dem jeweiligen Menüeintrag entspricht; der Array ist zu Beginn leer und soll vom User via AlertView befüllt werden, siehe weiter unten
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let myPath = tableView.indexPathForSelectedRow {
                let myDestinationVC = segue.destination as! DetailVC
                myDestinationVC.selectedTask = myMenue[myPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var finalTextField = UITextField() // Ein UITextField wird als Variable initialisiert, die jeder Methode innerhalb der IB-Action zur Verfügung steht; in der "addTextField-Methode" unten wird das Textfeld des Alert-ViewControllers dieser Variablen zugewiesen, damit die UIAlertAction-Methode auf dieses zugreifen kann!
        
        let myAlertVC = UIAlertController(title: "Add Task", message: "whatever you need or want to do", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK!", style: .default) { (action) in
            let myNewItem = Menue(context: self.myContext)
            myNewItem.items = finalTextField.text!
            self.myMenue.append(myNewItem)
            self.saveItems()
        }
        
        myAlertVC.addAction(myAction)
        myAlertVC.addTextField { (myTextField) in
            finalTextField = myTextField
        }
        present(myAlertVC, animated: true, completion: nil)
    }
    
    func loadItems() {
        
        do {
            myMenue = try myContext.fetch(fetching)
        }
        catch {
            print("\(error)")
        }
        self.tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try myContext.save()
        }
        catch {
            print("\(error)")
        }
        self.tableView.reloadData()
    }
}

