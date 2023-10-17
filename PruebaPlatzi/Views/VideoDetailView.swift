//
//  VideoDetailView.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 16/10/23.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    @ObservedObject var viewModel: VideoDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let actualVideoURL = viewModel.videoURL {
                    VideoPlayer(player: AVPlayer(url: actualVideoURL))
                        .aspectRatio(CGFloat(viewModel.video.width) / CGFloat(viewModel.video.height), contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.width * 9 / 16)
                        .overlay(
                            VStack {
                                HStack {
                                    Button(action: {
                                        viewModel.toggleFullScreen()
                                    }, label: {
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                            .foregroundColor(.white)
                                            .padding()
                                    })
                                    Spacer()
                                }
                                Spacer()
                            }
                        )
                } else if viewModel.errorMessage != nil {
                    Text(viewModel.errorMessage ?? "Ocurrió un error.")
                        .foregroundColor(.red)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 1) {
                        Text(viewModel.video.user?.name ?? "Desconocido")
                            .font(.headline)
                        Text(viewModel.video.durationText)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $viewModel.isFullScreen, content: {
            if let actualVideoURL = viewModel.videoURL {
                FullScreenVideoPlayer(videoURL: actualVideoURL)
            }
        })
        .navigationTitle(viewModel.video.user?.name ?? "Desconocido")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct VideoDetailView_Previews: PreviewProvider {
    
    static var mockUser: User {
        let user = User()
        user.id = 123
        user.name = "Ricardo Guerrero"
        user.url = "https://example.com/user_image.jpg"
        return user
    }
    
    static var mockVideoFile: VideoFile {
        let videoFile = VideoFile()
        videoFile.id = 456
        videoFile.quality = "hd"
        videoFile.fileType = "mp4"
        videoFile.width.value = 1920
        videoFile.height.value = 1080
        videoFile.link = "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4"
        return videoFile
    }

    static var mockVideo: Video {
        let video = Video()
        video.id = 789
        video.width = 1920
        video.height = 1080
        video.duration = 300
        video.user = mockUser
        video.videoFiles.append(mockVideoFile)
        return video
    }

    static var mockViewModel: VideoDetailViewModel {
        VideoDetailViewModel(video: mockVideo)
    }

    static var previews: some View {
        VideoDetailView(viewModel: mockViewModel)
    }
}

