//
//  ListView.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//
/*
import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewViewModel()
    @StateObject private var connectivityMonitor = ConnectivityMonitor()
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    PlatziLoader()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.videos.filter { !$0.isVertical }) { video in
                        ZStack {
                            VideoRow(video: video)
                            NavigationLink("", destination: Text("Detalles de video aquí")).opacity(0)
                        }
                        .padding(.vertical, 1)
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
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
            .onAppear(perform: {
                connectivityMonitor.startMonitoring()
            })
            .onDisappear(perform: {
                connectivityMonitor.stopMonitoring()
            })
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("Aceptar")))
            }
        }
    }
}
*/

import SwiftUI

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

struct ListView: View {
    @StateObject private var viewModel = ListViewViewModel()
    @ObservedObject var connectivityMonitor: ConnectivityMonitor = ConnectivityMonitor()
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    PlatziLoader()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.videos.filter { !$0.isVertical }) { video in
                        ZStack {
                            VideoRow(video: video)
                            NavigationLink("", destination: VideoDetailView(viewModel: VideoDetailViewModel(video: video))).opacity(0)
                        }
                        .padding(.vertical, 1)
                    }
                }
            }
            .navigationBarTitle("Platzi")
            .navigationBarItems(trailing:
                                    Image(systemName: connectivityMonitor.isConnected ? "wifi" : "wifi.slash")
                .foregroundColor(connectivityMonitor.isConnected ? .green : .red)
                .imageScale(.medium)
            )
            .refreshable(action: { viewModel.refreshVideos() })
            .onReceive(viewModel.$error) { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
            .onAppear(perform: {
                connectivityMonitor.startMonitoring()
            })
            .onDisappear(perform: {
                connectivityMonitor.stopMonitoring()
            })
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("Aceptar")))
            }
        }
    }
}
