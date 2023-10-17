//
//  PlatziLoader.swift
//  PruebaPlatzi
//
//  Created by Ricardo Guerrero Godínez on 17/10/23.
//

import SwiftUI

struct PlatziLoader: View {
    @State private var rotationDegree: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: -30) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: rotationDegree))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 3.5).repeatForever(autoreverses: false)) {
                            rotationDegree = 360
                        }
                    }
                Text("Cargando...")
                    .font(.title3)
                    .foregroundColor(Color(hex: "#98CA3F"))
            }
            .offset(x: 0, y: -80)
        }
    }
}

struct PlatziLoader_Previews: PreviewProvider {
    static var previews: some View {
        PlatziLoader()
    }
}
