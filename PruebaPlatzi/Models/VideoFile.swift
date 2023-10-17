//
//  VideoFile.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation
import RealmSwift

class VideoFile: Object, Identifiable, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var quality: String = ""
    @objc dynamic var fileType: String = ""
    var width = RealmOptional<Int>()
    var height = RealmOptional<Int>()
    @objc dynamic var link: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
