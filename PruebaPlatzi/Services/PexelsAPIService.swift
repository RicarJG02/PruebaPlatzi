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
    
    // Function to download a video and return the local URL
    func downloadVideo(videoUrl: URL) async throws -> URL {
        let (downloadedUrl, _) = try await URLSession.shared.download(from: videoUrl)
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(videoUrl.lastPathComponent)
        
        // Remove the file if it already exists at the localURL
        if FileManager.default.fileExists(atPath: localURL.path) {
            try FileManager.default.removeItem(at: localURL)
        }
        
        // Move the downloaded file to the localURL
        do {
            try FileManager.default.moveItem(at: downloadedUrl, to: localURL)
        } catch {
            print("Error saving video:", error)
            throw error
        }
        
        // Check if the video was saved successfully
        if FileManager.default.fileExists(atPath: localURL.path) {
            print("Video saved successfully at:", localURL.path)
            return localURL
        } else {
            print("Video not found at localURL")
            throw PexelsAPIError.videoDownloadFailed
        }
    }
}
