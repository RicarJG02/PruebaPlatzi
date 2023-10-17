//
//  VideoDetailViewModel.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation
import Network

class VideoDetailViewModel: ObservableObject {
    @Published var isFullScreen: Bool = false
    @Published var errorMessage: String?
    @Published var isConnected: Bool = true
    
    private var monitor: NWPathMonitor?
    
    var video: Video

    init(video: Video) {
        self.video = video
        startMonitoring()
        checkVideoFileAndSetError()
    }
    
    // Monitoreo de la conectividad
    private func startMonitoring() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.isConnected = true
                } else {
                    self?.isConnected = false
                }
            }
        }
    }
    
    deinit {
        monitor?.cancel()
    }

    var bestQualityVideoFile: VideoFile? {
        if let hdFile = video.videoFiles.first(where: { $0.quality == "hd" }) {
            return hdFile
        } else if let firstFile = video.videoFiles.first {
            return firstFile
        }
        return nil
    }

    var videoURL: URL? {
        if isConnected, let videoFile = bestQualityVideoFile {
            return URL(string: videoFile.link)
        } else if let localUrl = video.localUrl {
            // Revisar el LocalURL
            return URL(fileURLWithPath: localUrl)
        }
        return nil
    }

    func checkVideoFileAndSetError() {
        if bestQualityVideoFile == nil && video.localUrl == nil {
            errorMessage = "Error cargando el video."
        }
    }

    func toggleFullScreen() {
        isFullScreen.toggle()
    }
}
