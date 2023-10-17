//
//  FullScreenVideoPlayer.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import SwiftUI
import AVKit

struct FullScreenVideoPlayer: View {
    let videoURL: URL?
    
    var body: some View {
        if let url = videoURL {
            VideoPlayer(player: AVPlayer(url: url))
                .edgesIgnoringSafeArea(.all)
        } else {
            Text("Error cargando el video.")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
