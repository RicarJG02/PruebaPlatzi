//
//  ListViewViewModel.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation
import Combine
import RealmSwift

class ListViewViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil

    private var videoManager = VideoManager()
    private var realmService = RealmService()
    private var cancellables = Set<AnyCancellable>()
    private var connectivityMonitor = ConnectivityMonitor()

    init() {
        fetchVideos()
    }

    func fetchVideos() {
        isLoading = true

        // Verificar la conectividad antes de intentar hacer una petición
        if connectivityMonitor.isConnected {
            Task {
                do {
                    let videosFetched = try await VideoLoader().fetchAndUpdateVideos()
                    
                    // Guardar y recuperar los videos de Realm
                    let videosSaved = try await realmService.saveAndFetchVideos(videos: videosFetched)
                    
                    DispatchQueue.main.async {
                        self.videos = videosSaved
                        self.isLoading = false
                    }
                } catch {
                    // Si hay un error al obtener los videos desde el API, intentamos obtenerlos desde Realm.
                    fetchVideosFromDatabase()
                }
            }
        } else {
            fetchVideosFromDatabase()
        }
    }
    
    // Método para obtener los videos de Realm.
    func fetchVideosFromDatabase() {
        Task {
            do {
                let videosFetched = try await realmService.fetchVideosFromRealm()
                DispatchQueue.main.async {
                    self.videos = videosFetched
                    self.isLoading = false
                }
            } catch let realmError {
                DispatchQueue.main.async {
                    self.error = realmError
                    self.isLoading = false
                }
            }
        }
    }

    func refreshVideos() {
        fetchVideos()
    }
}
