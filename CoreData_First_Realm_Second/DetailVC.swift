//
//  DetailVC.swift
//  CoreData_First_Realm_Second
//
//  Created by Joachim Vetter on 14.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UITableViewController {

    let myContext2 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
    }
}
