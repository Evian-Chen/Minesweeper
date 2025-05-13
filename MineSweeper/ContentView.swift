//
//  ContentView.swift
//  Minesweeper
//
//  Created by mac03 on 2025/5/7.
//
//  Description:
//  ------------
//  Main entry view for the Minesweeper game.
//  Allows users to set board size, start/reset the game,
//  and displays the game board UI.
//

import SwiftUI

/// The main view that manages user input and game state transitions.
struct ContentView: View {
    // Define necessary variables
    @State var row = 5
    @State var col = 5
    @State var isStarted = false
    @State var isFirstClick = true

    @StateObject var minesweeperGame = MinesweeperGame()

    var body: some View {
        ZStack {
            // Background color
            Color(.systemGreen).opacity(0.1).ignoresSafeArea()

            VStack(spacing: 24) {
                // Title updates based on game state
                Text(isStarted ? "🎯 Let's Play Minesweeper!" : "⚙️ Setup Your Game")
                    .font(.largeTitle.bold())
                    .foregroundColor(.green)

                // Input fields for row and column
                rowColInputField(row: $row, col: $col)

                // Button to start the game
                Button {
                    minesweeperGame.initSize(row: row, col: col)
                    isStarted = true
                    isFirstClick = true
                } label: {
                    Text("🚀 Build Game")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal)

                // Display game board and reset button only when game is started
                if isStarted {
                    BoardView(minesweeperGame: minesweeperGame, isFirstClick: $isFirstClick)
                        .padding(.vertical)

                    Button {
                        isStarted = false
                        isFirstClick = false
                        minesweeperGame.resetGame()
                    } label: {
                        Text("🔄 Reset Game")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red.opacity(0.5), lineWidth: 2)
                            )
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .alert("Game Over", isPresented: $minesweeperGame.isGameOver) {
            Button("Reset Game") {
                minesweeperGame.resetGame()
                isStarted = false
                isFirstClick = true
            }
        }
        .alert("Game Over", isPresented: $minesweeperGame.isGameWin) {
            Button("You Win") {
                minesweeperGame.resetGame()
                isStarted = false
                isFirstClick = true
            }
        }
    }
}

/// A reusable UI block for inputting board size (row and column)
struct rowColInputField: View {
    @Binding var row: Int
    @Binding var col: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LabeledNumberField(label: "Row", systemImage: "rectangle.grid.1x2", value: $row)
            LabeledNumberField(label: "Col", systemImage: "rectangle.split.2x1", value: $col)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

/// A labeled text field with a system icon and integer binding.
struct LabeledNumberField: View {
    var label: String
    var systemImage: String
    @Binding var value: Int

    var body: some View {
        HStack {
            Label(label, systemImage: systemImage)
                .frame(width: 80, alignment: .leading)
            TextField("Enter \(label)", value: $value, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    ContentView()
}
