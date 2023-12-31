//
//  RealmService.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import Foundation
import RealmSwift

// MARK: - RealmService

class RealmService {
    
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    // Guarda los videos en Realm de forma asíncrona y luego los devuelve
    @discardableResult
    func saveAndFetchVideos(videos: [Video]) async throws -> [Video] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(videos, update: .modified)
                        print("Videos guardados exitosamente en Realm 🔥")
                    }
                    continuation.resume(returning: videos)
                } catch {
                    print("Error con Realm: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Recupera los videos de Realm de forma asíncrona
    func fetchVideosFromRealm() async throws -> [Video] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    let videos = Array(realm.objects(Video.self))
                    continuation.resume(returning: videos)
                } catch {
                    print("Error recuperando videos de Realm: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Guarda los metadatos de los videos en Realm de forma asíncrona y luego los devuelve
    func saveAndFetchMetadata(videos: [Video]) async throws -> [Video] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(videos, update: .modified)
                        print("Metadatos guardados exitosamente en Realm 📸")
                    }
                    continuation.resume(returning: videos)
                } catch {
                    print("Error con Realm al guardar metadatos: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Recupera los metadatos de los videos de Realm de forma asíncrona
    func fetchMetadataFromRealm() async throws -> [Video] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    let videos = Array(realm.objects(Video.self))
                    continuation.resume(returning: videos)
                } catch {
                    print("Error recuperando metadatos de Realm: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
