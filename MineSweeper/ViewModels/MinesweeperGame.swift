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
    
    @Published var isGameOver: Bool = false
    
    // MARK: - Initialization
    
    /// Default initializer with empty board
    init() {
        self.row = 0
        self.col = 0
        self.mineCount = 0
    }
    
    /// Initialize the game board with rows and columns and place the mines
    func initSize(row: Int, col: Int) {
        self.row = row
        self.col = col
//        self.mineCount = Int.random(in: 1 ..< row * col)
        self.mineCount = 5  // Test
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
    func updateBoard(pos: Position, isFirstClick: Bool, isLongPress: Bool) {
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
        
        // Handle state change of long press
        if isLongPress {
            if self.gameBoard[index].state == .hidden {
                self.gameBoard[index].state = .flagged
            } else if self.gameBoard[index].state == .flagged {
                self.gameBoard[index].state = .hidden
            }
        } else {  // click
            self.gameBoard[index].state = .revealed
            
            // 如果這格0而且不是地雷，展開四周
            if !self.gameBoard[index].isMine && self.gameBoard[index].adjacentMineCount == 0 {
                self.expandAdjacentCells(curPos: pos)
            }
        }
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
    
    func expandZero() {
        
    }
    
    func expandNonZero() {
        
    }
    
    /// 呼叫前已經確認此cell是0
    func expandAdjacentCells(curPos: Position) {
        let index = indexAt(pos: curPos)
        let cell = self.gameBoard[index]
        
        // 如果旁邊的地雷數量不是零，則要檢查每一個有地雷的格子都是旗子了
        if cell.adjacentMineCount != 0 {
            for pos in cell.adjacentPos {
                let adjCell = self.gameBoard[indexAt(pos: pos)]
                // 是炸彈，但是不是旗子
                if self.minePos.contains(pos) && adjCell.state != .flagged {
                    // 遊戲結束
                    self.gameLoss()
                }
                
                adjCell.state = .revealed
            }
        } else { // 旁邊的地雷數量是零
            for pos in cell.adjacentPos {
                let adjCell = self.gameBoard[indexAt(pos: pos)]
                
                adjCell.state = .revealed
                
                // 如果周邊還有是零的，一樣繼續展開
                if adjCell.adjacentMineCount == 0 {
                    self.expandAdjacentCells(curPos: pos)
                }
            }
        }
    }
    
    func gameLoss() {
        // 輸了，標示出所有的炸彈位置
        for pos in self.minePos {
            self.gameBoard[indexAt(pos: pos)].state = .revealed
        }
        self.isGameOver = true
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

