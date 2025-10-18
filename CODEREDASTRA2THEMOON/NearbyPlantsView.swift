import SwiftUI
import MapKit

struct NearbyPlantsView: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            Map(position: $position, interactionModes: .all, selection: .constant(nil)) {
                ForEach(searchResults, id: \.self) { item in
                    if let coordinate = item.placemark.location?.coordinate {
                        Annotation(item.name ?? "Recycling Center", coordinate: coordinate) {
                            ZStack {
                                Circle().fill(.green).frame(width: 28, height: 28)
                                Image(systemName: "leaf")
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        Task { await searchNearbyRecyclingCenters() }
                    } label: {
                        if isSearching {
                            ProgressView()
                        } else {
                            Label("Find Nearby", systemImage: "magnifyingglass")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Nearby Centers")
            .task { await searchNearbyRecyclingCenters() }
        }
    }

    private func searchNearbyRecyclingCenters() async {
        isSearching = true
        defer { isSearching = false }
        do {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "recycling center"
            request.resultTypes = .pointOfInterest
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            await MainActor.run {
                self.searchResults = response.mapItems
            }
        } catch {
            // In a production app, surface an error state to the user.
            print("Search failed: \(error)")
        }
    }
}
