//
//  User.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation
import RealmSwift

class User: Object, Identifiable, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
