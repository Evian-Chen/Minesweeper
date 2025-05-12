//
//  BoardView.swift
//  MineSweeper
//
//  Created by mac03 on 2025/5/9.
//
//  Description:
//  ------------
//  This file defines the BoardView, which visually represents the Minesweeper grid.

import SwiftUI

/// A view representing the full Minesweeper game board.
struct BoardView: View {
    
    /// The game logic that provides game data and handles updates
    @ObservedObject var MinesweeperGame: MinesweeperGame
    
    /// Biding to indicate if the first click occured
    @Binding var isFirstClick: Bool
    
    var body: some View {
        VStack {
            ForEach(0 ..< MinesweeperGame.row, id: \.self) { i in
                HStack {
                    ForEach(0 ..< MinesweeperGame.col, id: \.self) { j in
                        let index = i * MinesweeperGame.col + j
                        
                        // Render individual cell with tap handling
                        CellView(cell: MinesweeperGame.gameBoard[index]) {
                            MinesweeperGame.updateBoard(pos: Position(row: i, col: j),
                                                        isFirstClick: isFirstClick, isLongPress: false)
                            isFirstClick = false
                        } longPressAction: {
                            MinesweeperGame.updateBoard(pos: Position(row: i, col: j),
                                                        isFirstClick: isFirstClick, isLongPress: true)
                            // If the first click is long press, then still count it as the first click
                            isFirstClick = false
                        } // CellView
                    } // j
                } // HStack
            } // i
        } // VStack
    }
}
