//
//  VideoRow.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import SwiftUI

struct VideoRow: View {
    var video: Video
    
    var imageUrl: URL? {
        if let localImageUrl = video.localImageUrl, !localImageUrl.isEmpty {
            return URL(fileURLWithPath: localImageUrl)
        } else {
            return URL(string: video.image)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    AnyView(Rectangle().foregroundColor(.gray))
                case .success(let image):
                    AnyView(image.resizable().aspectRatio(16/9, contentMode: .fit))
                case .failure:
                    AnyView(Image(systemName: "xmark.circle"))
                @unknown default:
                    AnyView(ProgressView())
                }
            }
            .frame(height: 210)
            .clipped()
            
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(video.user?.name ?? "Desconocido")
                        .font(.headline)
                        .lineLimit(1)
                    Text(video.durationText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(Color(hex: "#98CA3F"))
                    .padding(.trailing)
            }
        }
        .background(Color.clear)
    }
}
