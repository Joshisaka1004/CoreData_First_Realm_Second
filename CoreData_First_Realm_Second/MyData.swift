//
//  MyData.swift
//  CoreData_First_Realm_Second
//
//  Created by Joachim Vetter on 16.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import Foundation
import RealmSwift

class MyData: Object {
    @objc dynamic var myName: String = ""
    @objc dynamic var myAge: Int = 51
}
