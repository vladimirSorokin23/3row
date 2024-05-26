//
//  MainView.swift
//  DogHouses
//
//

import SwiftUI

struct MainView: View {
    // MARK: - Properties
    // MARK: - View body
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Group {
                    NavigationLink(destination: GameView().environmentObject(GameModel())) {
                        Text("NEW GAME")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    NavigationLink(destination: StatisticsView()) {
                        Text("STATISTICS")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .padding(10)
                .background(.button)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background {
                Image(.mainBack)
                    .resizable()
                    .ignoresSafeArea()
            }
            .overlay(alignment: .top) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
            }
            .overlay(alignment: .bottom) {
                Image(.dogs)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    MainView()
}
