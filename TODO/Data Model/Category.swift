//
//  Category.swift
//  TODO
//
//  Created by 南继云 on 2020/12/29.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    
    let items = List<Item>()
}
