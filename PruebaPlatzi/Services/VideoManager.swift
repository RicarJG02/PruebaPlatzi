//
//  VideoManager.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation

// MARK: - VideoManager

class VideoManager {
    let apiService = PexelsAPIService()
    let realmService = RealmService()
    let connectivityMonitor = ConnectivityMonitor()
    
    var isConnectedToInternet: Bool {
        return connectivityMonitor.isConnected
    }
    
    enum VideoManagerError: Error {
        case noInternetConnection
    }
    
    func downloadAndStoreMetadata() async throws {
        guard isConnectedToInternet else {
            print("No hay conexión a Internet.")
            throw VideoManagerError.noInternetConnection
        }
        
        let videos = try await fetchVideosFromAPI()
        var updatedVideos: [Video] = []
        
        let metadataDownloadTasks = videos.map { video in
            return Task<Video?, Error> {
                let tmpVideo = video
                
                // Descargar y guardar la imagen
                let imageUrlString = video.image
                if let imageUrl = URL(string: imageUrlString) {
                    do {
                        let localImageUrl = try await apiService.downloadImage(imageUrl: imageUrl)
                        tmpVideo.localImageUrl = localImageUrl.absoluteString
                        print("Local Image URL: \(tmpVideo.localImageUrl ?? "")📸")
                    } catch {
                        print("Error downloading image:", error)
                        return nil
                    }
                }
                return tmpVideo
            }
        }
        
        for task in metadataDownloadTasks {
            do {
                if let video = try await task.value {
                    updatedVideos.append(video)
                }
            } catch {
                print("Error:", error)
            }
        }
        _ = try await realmService.saveAndFetchMetadata(videos: updatedVideos)
    }
    
    func downloadVideos() async throws -> [Video] {
        guard isConnectedToInternet else {
            print("No hay conexión a Internet.")
            throw VideoManagerError.noInternetConnection
        }
        
        let videosFromAPI = try await fetchVideosFromAPI()
        var downloadedVideos: [Video] = []
                
        let downloadTasks = videosFromAPI.map { video in
            return Task<Video?, Error> {
                let tmpVideo = video
                
                // Verificar si el video ya existe en el almacenamiento local usando FileManager
                if let localUrlString = tmpVideo.localUrl,
                   let localURL = URL(string: localUrlString),
                   FileManager.default.fileExists(atPath: localURL.path) {
                    print("Video ya existe localmente, omitiendo la descarga.")
                    return tmpVideo
                }
                
                // Continuar con la descarga si el video no existe localmente
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
    }
    
    func loadVideos() async throws -> [Video] {
        if isConnectedToInternet {
            return try await fetchVideosFromAPI()
        } else {
            return try await realmService.fetchVideosFromRealm()
        }
    }
    
    func fetchVideosFromAPI() async throws -> [Video] {
        try await apiService.fetchVideos()
    }
}
