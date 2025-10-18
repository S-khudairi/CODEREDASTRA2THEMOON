import SwiftUI

struct PointsLeaderboardView: View {
    @State private var myPoints: Int = 420
    @State private var weeklyHistory: [Int] = [5, 12, 8, 20, 15, 10, 18]
    @State private var leaderboard: [UserScore] = [
        .init(name: "Ava", points: 950),
        .init(name: "Liam", points: 880),
        .init(name: "Mia", points: 845),
        .init(name: "Noah", points: 830),
        .init(name: "Olivia", points: 820),
        .init(name: "Ethan", points: 800),
        .init(name: "Sophia", points: 790),
        .init(name: "James", points: 770),
        .init(name: "Emma", points: 760),
        .init(name: "Lucas", points: 750)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    pointsHeader
                    weeklyChart
                    leaderboardSection
                }
                .padding()
            }
            .navigationTitle("Points & Leaderboard")
        }
    }

    private var pointsHeader: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Points")
                    .font(.headline)
                Text("\(myPoints)")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
            }
            Spacer()
            Button {
                // Placeholder for redeem action
            } label: {
                Label("Redeem", systemImage: "gift")
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("This Week", systemImage: "chart.bar.fill")
                .font(.headline)
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(weeklyHistory.enumerated()), id: \.offset) { _, value in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor.opacity(0.8))
                        .frame(width: 18, height: CGFloat(max(value, 2)) * 6)
                        .accessibilityLabel("Day points: \(value)")
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .bottom)
            .padding(.vertical, 8)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private var leaderboardSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Top 10", systemImage: "trophy")
                .font(.headline)
            ForEach(Array(leaderboard.enumerated()), id: \.offset) { index, user in
                HStack {
                    Text("#\(index + 1)")
                        .font(.subheadline)
                        .frame(width: 30, alignment: .leading)
                    Text(user.name)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(user.points)")
                        .font(.body.monospaced())
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(index == 0 ? Color.yellow.opacity(0.2) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

struct UserScore: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let points: Int
}
