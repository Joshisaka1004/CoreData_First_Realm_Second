//
//  Task.swift
//  CoreData_First_Realm_Second
//
//  Created by Joachim Vetter on 17.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name: String = ""
    var parent = LinkingObjects(fromType: Menue.self, property: "myChildren")
}
