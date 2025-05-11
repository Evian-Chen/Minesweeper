//
//  MinesweeperGame.swift
//  MineSweeper
//
//  Created by mac03 on 2025/5/9.
//
//  Description:
//  ------------
//  This file contains the core logic of Minesweeper, including board generation,
//  mine placement and state update.

import SwiftUI

/// The central game logic manager for Minesweeper
class MinesweeperGame: ObservableObject {
    /// Number of rows in the board
    var row: Int
    
    /// Number of columns in the board
    var col: Int
    
    /// Number of mine placed in the board
    var mineCount: Int
    
    /// Positions of all the mines in the board
    private var minePos: Set<Position> = []
    
    /// The game board consisting of the Cell objects
    @Published var gameBoard: [Cell] = []
    
    // MARK: - Initialization
    
    /// Default initializer with empty board
    init() {
        self.row = 0
        self.col = 0
        self.mineCount = 0
    }
    
    // Initialize the game board with rows and columns and place the mines
    func initSize(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.mineCount = Int.random(in: 1 ..< row * col)
        self.generateBoard()
    }
    
    // MARK: - Board Setup
    
    /// Create a clean board with all Cell as non-mine and hidden
    func generateBoard() {
        for i in 0 ..< row * col {
            self.gameBoard.append(Cell(pos: Position(row: i / row, col: i % col),
                                       boardRow: self.row,
                                       boardCol: self.col,
                                       isMine: false,
                                       state: .hidden))
        }
    }
    
    /// Place mines randomly on the board, avoiding first click position
    /// - Parameters:
    ///    - firstPos: the position of first click
    func generateMine(firstPos: Position) {
        self.minePos.removeAll()
        
        while self.minePos.count < self.mineCount {
            let ranR = Int.random(in: 0 ..< self.row)
            let ranC = Int.random(in: 0 ..< self.col)
            let pos = Position(row: ranR, col: ranC)
            if (pos != firstPos) {
                
                // Make sure pos is inserted then update the adjacent mine count
                if self.minePos.insert(pos).inserted {
                    self.gameBoard[self.indexAt(pos: pos)].isMine = true
                    self.updateAdjacentMineCount(curPos: pos)
                }
            }
        }
    }
    
    // MARK: - Game Logic
    
    /// Handle user tap interaction
    /// - Parameters:
    ///   - pos: the tapped position
    ///   - isFirstClick: true if this is the first move of the game
    func updateBoard(pos: Position, isFirstClick: Bool) {
        let index = self.indexAt(pos: pos)
        
        if isFirstClick {
            // Test, check positions of all mines
            var _ = self.getMinePos()
            
            self.generateMine(firstPos: pos)
        } else if self.gameBoard[index].isMine {
            // game over
        }
        
        self.printAdjacent(pos: pos)
        print("adjacent mine count: \(self.gameBoard[self.indexAt(pos: pos)].adjacentMineCount)")
        print("all mine count: \(self.mineCount)")
        
        self.gameBoard[index].state = .revealed
    }
    
    /// Update the adjacent mine count after placing a mine at curPos
    ///  - Parameters:
    ///     - curPos: the current position of the placed mine
    func updateAdjacentMineCount(curPos: Position) {
        let cell = self.gameBoard[indexAt(pos: curPos)]
        for pos in cell.adjacentPos {
            self.gameBoard[indexAt(pos: pos)].adjacentMineCount += 1
        }
    }
    
    /// Reset the entire game state and clear the board
    func resetGame() {
        self.gameBoard.removeAll()
        self.row = 0
        self.col = 0
        self.mineCount = 0
    }
    
    // MARK: - Utilities
    
    /// Convert a position to a linear index
    func indexAt(pos: Position) -> Int {
        return pos.row * self.col + pos.col
    }
    
    /// Return positions of all mines in the board
    func getMinePos() -> Set<Position> {
        // print here to debug
        for pos in self.minePos {
            print("mine pos: \(pos.row), \(pos.col)")
        }
        return self.minePos
    }
    
    /// Just for dubugging
    func printAdjacent(pos: Position) {
        print("adjacent position of \(pos.row), \(pos.col):")
        for p in self.gameBoard[indexAt(pos: pos)].adjacentPos {
            print("\(p.row), \(p.col)")
        }
    }
    
    /// return the full board
    func getBoard() -> [Cell] {
        return self.gameBoard
    }
}

