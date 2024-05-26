//
//  StatisticsView.swift
//  FruttyTreats
//
//

import SwiftUI

struct StatisticsView: View {
    // MARK: - Properties
    @AppStorage(UserDefaultsKeys.stat) var statisticsData: Data?
    @State var stats: [String: Int] = [:]
    // MARK: - View body
    var body: some View {
        ZStack {
            Image(.statBack)
                .resizable()
                .ignoresSafeArea()
            Section {
                List(stats.keys.sorted(), id: \.self) { key in
                    HStack {
                        Text("\(key)")
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(stats[key] ?? 0)")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.button.opacity(0.9))
                }
                .listStyle(.plain)
                .listRowSpacing(10)
            }
            .padding()
        }
        .task {
            guard let statisticsData else { return }
            decodeDictionary(from: statisticsData)
        }
    }
    // MARK: - Private methods
    private func decodeDictionary(from data: Data) {
        let dict = try? JSONDecoder().decode([String: Int].self, from: data)
        guard let dict else { return  }
        stats = dict
    }
}

#Preview {
    StatisticsView()
}
