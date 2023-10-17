//
//  VideoPicture.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation
import RealmSwift

class VideoPicture: Object, Identifiable, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var picture: String = ""
    @objc dynamic var nr: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
