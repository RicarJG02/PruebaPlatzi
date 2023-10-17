//
//  Functions.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation

extension Video {
    var isVertical: Bool {
        return height > width
    }
}

extension Video {
    var durationText: String {
        let minutes = duration / 60
        let seconds = duration % 60
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds) mins"
    }
}
