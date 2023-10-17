//
//  VideoManager.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation

// MARK: - VideoManager

class VideoManager {
    private let apiService = PexelsAPIService()
    private let realmService = RealmService()
    private let connectivityMonitor = ConnectivityMonitor()
    
    var isConnectedToInternet: Bool {
        return connectivityMonitor.isConnected
    }
    
    func loadVideos() async throws -> [Video] {
        if isConnectedToInternet {
            let videos = try await apiService.fetchVideos()
            var downloadedVideos: [Video] = []
            
            let downloadTasks = videos.map { video in
                return Task<Video?, Error> {
                    var tmpVideo = video
                    if let videoString = video.videoFiles.first?.link,
                       let videoURL = URL(string: videoString) {
                        do {
                            let updatedVideoUrl = try await apiService.downloadVideo(videoUrl: videoURL)
                            tmpVideo.localUrl = updatedVideoUrl.absoluteString
                            print("LocalURL:\(tmpVideo.localUrl ?? "")🔥")
                            return tmpVideo
                        } catch {
                            print("Error downloading video:", error)
                            return nil
                        }
                    }
                    return nil
                }
            }
            
            for task in downloadTasks {
                do {
                    if let video = try await task.value {
                        downloadedVideos.append(video)
                    }
                } catch {
                    print("Error:", error)
                }
            }
            
            let savedVideos = try await realmService.saveAndFetchVideos(videos: downloadedVideos)
            return savedVideos
        } else {
            return try await realmService.fetchVideosFromRealm()
        }
    }
}
