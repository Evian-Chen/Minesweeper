//
//  Cell.swift
//  MineSweeper
//
//  Created by mac03 on 2025/5/9.
//
//  Description:
//  ------------
//  This file defines a single Cell in the game board.

import SwiftUI


/// A single Cell in the game board, may include mine or flag
class Cell: ObservableObject, Identifiable {
    var id = UUID()
    
    /// Position on the game board
    var pos: Position
    
    /// Sizes of the main game board
    var boardRow: Int
    var boardCol: Int
    
    /// Number od surrounding mines
    var adjacentMineCount: Int = 0
    
    /// Indexes of surrounding cell, you can check the surrounding cell by looping through this variable
    var adjacentPos: [Position] {
        let r = pos.row
        let c = pos.col
        
        var temp: [Position] = []
        
        for i in -1 ... 1 {
            for j in -1 ... 1 {
                if (0 <= (r + i)) && (r + i) < boardRow && (0 <= (c + j)) && (c + j) < boardCol && !((r + i) == r && (c + j) == c) {
                    let pos = Position(row: (r + i), col: c + j)
                    temp.append(pos)
                }
            }
        }
        
        return temp
    }
    
    /// The cell is a mine or not
    @Published var isMine: Bool
    
    /// Current state (hidden / revealed / flagged)
    @Published var state: CellState
    
    init(pos: Position, boardRow: Int, boardCol: Int, isMine: Bool, state: CellState) {
        self.pos = pos
        self.boardRow = boardRow
        self.boardCol = boardCol
        self.isMine = isMine
        self.state = state
    }
}
