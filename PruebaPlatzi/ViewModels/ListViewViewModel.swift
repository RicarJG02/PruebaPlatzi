//
//  ListViewViewModel.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation
import Combine

class ListViewViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil

    private var videoManager = VideoManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchVideos()
    }

    func fetchVideos() {
        isLoading = true
        Task {
            do {
                let videosFetched = try await VideoLoader().fetchAndUpdateVideos()
                DispatchQueue.main.async {
                    self.videos = videosFetched
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }

    func refreshVideos() {
        fetchVideos()
    }
}


/*
 do {
     let videosFetched = try await videoManager.loadVideos()
     let filteredVideos = videosFetched.filter { !$0.isVertical }
     DispatchQueue.main.async {
         // Convierte los objetos en objetos seguros para pasar entre hilos aquí, si es necesario.
         self.videos = filteredVideos
         self.isLoading = false
     }
 } catch {
     DispatchQueue.main.async {
         self.error = error
         self.isLoading = false
     }
 }
 */
