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
    
    /// The cell is a mine or not
    @Published var isMine: Bool
    
    /// Current state (hidden / revealed / flagged)
    @Published var state: CellState
    
    init(pos: Position, isMine: Bool, state: CellState) {
        self.pos = pos
        self.isMine = isMine
        self.state = state
    }
}
