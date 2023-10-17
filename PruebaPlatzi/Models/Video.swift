//
//  Video.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation
import RealmSwift

class Video: Object, Identifiable, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var duration: Int = 0
    @objc dynamic var user: User?
    @objc dynamic var localUrl: String? = nil
    var videoFiles = List<VideoFile>()
    var videoPictures = List<VideoPicture>()
    override static func primaryKey() -> String? {
        return "id"
    }
    private enum CodingKeys: String, CodingKey {
        case id, width, height, url, image, duration, user, videoFiles, videoPictures
    }
}
