//
//  ContentView.swift
//  CODEREDASTRA2THEMOON
//
//  Created by Sam Khudairi on 10/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CaptureAnalyzeView()
                .tabItem {
                    Label("Capture", systemImage: "camera.viewfinder")
                }
            
            NearbyPlantsView()
                .tabItem {
                    Label("Nearby", systemImage: "mappin.and.ellipse")
                }
            
            PointsLeaderboardView()
                .tabItem {
                    Label("Points", systemImage: "trophy")
                }
        }
    }
}

#Preview {
    ContentView()
}
