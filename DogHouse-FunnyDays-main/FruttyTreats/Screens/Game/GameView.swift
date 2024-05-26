//
//  ContentView.swift
//  Shared
//
//  Created by Joshua Homann
//

import Combine
import SwiftUI

struct GameView: View {
    private enum Space: Hashable {
        case board
    }
    
    @AppStorage(UserDefaultsKeys.stat) var statisticsData: Data?
    @EnvironmentObject private var gameModel: GameModel
    @State private var squares = [Int: CGRect]()
    @State private var selectedIndex: Int? = nil
    @State private var selectionOpacity = 0.5
    @State private var canMove = true

    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
                .overlay(
                    ZStack(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 50) {
                            VStack(spacing: 70) {
                                Image(.logo)
                                    .resizable()
                                    .frame(width: 300, height: 135)
                                ZStack(alignment: .topLeading) {
                                    ZStack {
                                        VStack(spacing: 0) {
                                            ForEach(0..<GameModel.Constant.boardHeight, id: \.self) { y in
                                                HStack(spacing: 0) {
                                                    ForEach(0..<GameModel.Constant.boardWidth, id: \.self) { x in
                                                        let index = x + y * GameModel.Constant.boardWidth
                                                        let background = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
                                                        GeometryReader { proxy in
                                                            RoundedRectangle(cornerRadius: proxy.size.width*0.1)
                                                                .aspectRatio(1, contentMode: .fit)
                                                                .preference(
                                                                    key: SquaresPreferenceKey.self,
                                                                    value: [index: proxy.frame(in: .named(Space.board))]
                                                                )
                                                                .foregroundColor(Color(background).opacity(0.01))
                                                        }
                                                        .onTapGesture { Task { await handleTap(at: index) } }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .aspectRatio(GameModel.Constant.aspectRatio, contentMode: .fit)
                                    .padding()
                                    .background(
                                        Image(.table)
                                            .resizable()
                                            .aspectRatio(GameModel.Constant.aspectRatio, contentMode: .fit)
                                    )
                                    if let selectedIndex = selectedIndex, let rect = squares[selectedIndex] {
                                        RoundedRectangle(cornerRadius: rect.width*0.1)
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: rect.size.width)
                                            .offset(x: rect.minX, y: rect.minY)
                                            .foregroundColor(Color.purple)
                                            .opacity(selectionOpacity)
                                            .onAppear { selectionOpacity = 1.0 }
                                            .onDisappear { selectionOpacity = 0.5 }
                                            .animation(Animation.easeInOut(duration: 1).repeatForever(), value: selectionOpacity)
                                            .allowsHitTesting(false)
                                    }
                                    ForEach(gameModel.cells) { cell in
                                        let square = squares[cell.position] ?? .init(origin: .zero, size: .zero)
                                        let rect = square.insetBy(dx: square.size.width * 0.1, dy: square.size.height * 0.1)
                                        Image(ImageResource(name: GameModel.Constant.cellContents[cell.content], bundle: .main))
                                            .resizable()
                                            .foregroundColor(Color(GameModel.Constant.colors[cell.content]))
                                            .frame(width: rect.size.width, height: rect.size.height)
                                            .scaleEffect(cell.isMatched ? 1e-6 : 1, anchor: .center)
                                            .offset(x: rect.minX, y: rect.minY)
                                            .transition(.move(edge: .top))
                                            .shadow(radius: 2)
                                            .allowsHitTesting(false)
                                    }
                                }
                                .coordinateSpace(name: Space.board)
                                .onPreferenceChange(SquaresPreferenceKey.self) { squares = $0 }
                            }
                            Text("SCORE : \(gameModel.score)")
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                )
        }
        .onAppear {
            gameModel.reset()
        }
        .onDisappear {
            guard gameModel.score != 0 else { return }
            saveStat()
            gameModel.score = 0
        }
    }
    
    // MARK: - Private methods
    private func saveStat() {
        let currentDate = Date.now.formatted(date: .abbreviated, time: .shortened)
        guard let statisticsData else {
            let dict = [currentDate: gameModel.score]
            encodeStatData(from: dict)
            return
        }
        var dict = try? JSONDecoder().decode([String: Int].self, from: statisticsData)
        dict?[currentDate] = gameModel.score
        encodeStatData(from: dict)
    }

    private func encodeStatData(from dict: [String: Int]?) {
        guard let dict else { return }
        guard let data = try? JSONEncoder().encode(dict) else { return }
        statisticsData = data
    }

    private func handleTap(at index: Int) async {
        let cell = gameModel.cells[index]
        guard selectedIndex != cell.position else { return selectedIndex = nil }
        guard let selectedIndex = selectedIndex else { return selectedIndex = cell.position }
        guard canMove, GameModel.isAdjacent(selectedIndex, to: cell.position) else { return }
        self.selectedIndex = nil
        canMove = false
        defer { canMove = true }
        await animate(with: .easeInOut(duration:0.5)) {
            gameModel.exchange(selectedIndex, with: cell.position)
        }
        guard gameModel.hasMatches else {
            return await animate(with: .easeInOut(duration:0.5)) {
                gameModel.exchange(selectedIndex, with: cell.position)
            }
        }
        while gameModel.hasMatches {
            await animate(with: .linear(duration:0.25)) {
                gameModel.removeMatches()
            }
            while(gameModel.canCollapse) {
                await animate(with: .linear(duration:0.15)) {
                    gameModel.collapse()
                }
            }
        }
    }
}
