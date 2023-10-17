//
//  ListView.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewViewModel()
    @StateObject private var connectivityMonitor = ConnectivityMonitor()
        
    var body: some View {
        NavigationView {
            List(viewModel.videos) { video in
                NavigationLink(destination: Text("Detalles de video aquí")) {
                    HStack {
                        AsyncImage(url: URL(string: video.image)) { phase in
                            switch phase {
                            case .empty: ProgressView()
                            case .success(let image): image.resizable()
                            case .failure: Image(systemName: "xmark.circle")
                            @unknown default: ProgressView()
                            }
                        }
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fill)
                        
                        VStack(alignment: .leading) {
                            Text(video.user?.name ?? "Desconocido")
                            Text(video.durationText)
                        }
                    }
                }
            }
            .navigationBarTitle("Platzi")
            .navigationBarItems(trailing:
                                    Image(systemName: connectivityMonitor.isConnected ? "wifi" : "wifi.slash")
                .foregroundColor(connectivityMonitor.isConnected ? .green : .red)
                .imageScale(.medium)
            )
            .refreshable(action: viewModel.refreshVideos)
            .onReceive(viewModel.$error) { error in
                if let error = error {
                    // Manejar el error aquí
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
