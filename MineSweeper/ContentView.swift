//
//  ContentView.swift
//  MineSweeper
//
//  Created by mac03 on 2025/5/7.
//

import SwiftUI

enum cellState {
    case hidden, revealed, flagged
}

struct Cell {
    var curIndex: Int = 0
    var rowIndex: Int = 0
    var colIndex: Int = 0
    var isMine: Bool = false
    var state: cellState = .hidden
}

struct cellView: View {
    var cell: Cell
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray)
                .frame(width: 25, height: 25)
        }
        .padding(5)
    }
}

class GameBoard: ObservableObject {
    private var row: Int
    private var col: Int
    private var totalCell: Int
    private var mine: Int
    private var minePos: [(Int, Int)]
    
    @Published var gameBoard: [Cell]
    
    init() {
        self.row = 0
        self.col = 0
        self.totalCell = 0
        self.mine = 0
        self.minePos = [(-1, -1)]
        self.gameBoard = []
    }
    
    // after gotten row/col information, setup the board
    func setUpBoard(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.totalCell = row * col
        self.mine = Int((Double(self.totalCell) * 0.1).rounded()) + 1 // avoid zero mine
        self.gameBoard = []  // in case reset
        for i in 0 ..< self.totalCell {
            gameBoard.append(Cell(curIndex: i, rowIndex: i / self.col, colIndex: i % self.col))
        }
    }
    
    // UI call this function when it meets the first click of this board
    // input row and col
    func firstClick(row: Int, col: Int) {
        // generate mines
        var mineRow = Int.random(in: 0 ..< self.row)
        var mineCol = Int.random(in: 0 ..< self.col)
        
        for i in 0 ..< self.totalCell {
            while (mineRow == row && mineCol == col) {
                var mineRow = Int.random(in: 0 ..< self.row)
                var mineCol = Int.random(in: 0 ..< self.col)
            }
            
            self.gameBoard[row * self.row + col * self.col].isMine = true
            self.minePos.append( (mineRow, mineCol) )
            
            var mineRow = Int.random(in: 0 ..< self.row)
            var mineCol = Int.random(in: 0 ..< self.col)
        }
    }
    
    // getter function, this function returns all mine positions
    func getMinePos() -> [(Int, Int)] {
        return self.minePos
    }
    
    // return the view of gameboard
    @ViewBuilder
    func makeBoardView() -> some View {
        LazyVStack {
            ForEach(0 ..< self.totalCell) { index in
                cellView(cell: self.gameBoard[index])
            }
        }
    }
}

struct ContentView: View {
    @State var row = 0
    @State var col = 0
    @State var buildGame = false
    @State var firstBuild = true
    @StateObject var gameBoard = GameBoard()
    
    var body: some View {
        // input
        HStack() {
            TextField("Row: ", value: $row, formatter: NumberFormatter())
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
            
            TextField("Col: ", value: $col, formatter: NumberFormatter())
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
        }
        
        // Button
        HStack {
            Button {
                buildGame = true
                gameBoard.setUpBoard(row: row, col: col)
            } label: {
                Text("build game")
                    .padding()
                    .frame(width: .infinity)
                    .background(buildGame ? .gray.opacity(0.4) : .green.opacity(0.4))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Button {
                buildGame = false
            } label: {
                Text("reset game")
                    .padding()
                    .frame(width: .infinity)
                    .background(buildGame ? .green.opacity(0.4) : .red.opacity(0.4))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            gameBoard.makeBoardView()
        }
        
        if buildGame {
            Text("buildGame is true")
        } else {
            Text("Enter the new row and column and click build game to set up a new game")
        }
        
    }
}

#Preview {
    ContentView(gameBoard: GameBoard())
}
