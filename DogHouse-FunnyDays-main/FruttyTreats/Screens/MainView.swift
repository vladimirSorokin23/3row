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
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                Spacer()
                    .frame(height: 95)
                Group {
                    NavigationLink(destination: GameView().environmentObject(GameModel())) {
                        Text("Start Game")
                            .bold()
                            .padding(.vertical, 14)
                            .padding(.horizontal, 55)
                            .font(.title)
                            .foregroundStyle(.button)
                            .background(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.button, lineWidth: 4)
                            )
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background {
                Image(.mainBack)
                    .resizable()
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    MainView()
}
