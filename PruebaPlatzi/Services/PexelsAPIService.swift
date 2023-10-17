//
//  PexelsAPIService.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation

// MARK: - PexelsAPIService

struct PexelsVideoResponse: Decodable {
    let videos: [Video]
}

class PexelsAPIService {
    private let apiKey = "X3xN2psatjttzYi1mhTnMdbY9VprJotmCC5qcnxgbbPzSKaeuLpGDFfj"
    private let baseUrl = "https://api.pexels.com/"
    
    enum PexelsAPIError: Error {
        case videoDownloadFailed
        case imageDownloadFailed
    }
    
    // Fetch videos from the API
    func fetchVideos() async throws -> [Video] {
        guard let url = URL(string: baseUrl + "videos/popular?per_page=10") else {
            print("Error: Invalid URL")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(PexelsVideoResponse.self, from: data)
            return response.videos
        } catch {
            print("Error decoding: \(error)")
            throw error
        }
    }
    
    // Download image and return the local URL
    func downloadImage(imageUrl: URL) async throws -> URL {
        let (data, _) = try await URLSession.shared.data(from: imageUrl)
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        try data.write(to: fileURL)
        return fileURL
    }
    
    // Download video and return the local URL
    func downloadVideo(videoUrl: URL) async throws -> URL {
        // Obtener el nombre esperado del archivo local basado en la URL del video
        let expectedLocalURL = FileManager.default.temporaryDirectory.appendingPathComponent(videoUrl.lastPathComponent)
        
        // Verificar si el video ya existe localmente
        if FileManager.default.fileExists(atPath: expectedLocalURL.path) {
            print("Video ya existe localmente, omitiendo la descarga.")
            return expectedLocalURL
        }
        
        // Si el video no existe localmente, proceder con la descarga
        let (data, _) = try await URLSession.shared.data(from: videoUrl)
        
        try data.write(to: expectedLocalURL)
        return expectedLocalURL
    }
}

// MARK: - Video Loading and Storing

class VideoLoader {
    private let videoManager = VideoManager()
    private let realmService = RealmService()

    func fetchAndUpdateVideos() async throws -> [Video] {
        try await videoManager.downloadAndStoreMetadata()
        
        let videosFromAPI = try await videoManager.fetchVideosFromAPI()
        
        Task {
            do {
                _ = try await videoManager.downloadVideos()
            } catch {
                print("Error downloading videos: \(error)")
            }
        }
        
        return videosFromAPI
    }
}
