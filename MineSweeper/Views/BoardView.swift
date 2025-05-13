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
    @ObservedObject var minesweeperGame: MinesweeperGame
    
    /// Biding to indicate if the first click occured
    @Binding var isFirstClick: Bool
    
    var body: some View {
        VStack {
            ForEach(0 ..< minesweeperGame.row, id: \.self) { i in
                HStack {
                    ForEach(0 ..< minesweeperGame.col, id: \.self) { j in
                        let index = i * minesweeperGame.col + j
                        
                        // Render individual cell with tap handling
                        CellView(cell: minesweeperGame.gameBoard[index]) {
                            minesweeperGame.updateBoard(pos: Position(row: i, col: j),
                                                        isFirstClick: isFirstClick, isLongPress: false)
                            isFirstClick = false
                            
                            // 設定該cell的周邊地雷數量，再顯示到畫面上
                            minesweeperGame.setAdjacentMineCount(cell: minesweeperGame.gameBoard[index])
                        } longPressAction: {
                            minesweeperGame.updateBoard(pos: Position(row: i, col: j),
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
