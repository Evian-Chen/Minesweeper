//
//  CellView.swift
//  MineSweeper
//
//  Created by mac03 on 2025/5/9.
//
//  Description:
//  ------------
//  This file defines the behaviors of a single Cell in the game board,
//  including tap handeling and color.

import SwiftUI

/// A single tile view representing one cell on the Minesweeper board
struct CellView: View {
    @ObservedObject var cell: Cell
    
    /// Closure triggered when the user taps this cell
    let tapAction: () -> Void
    
    let longPressAction: () -> Void
    
    /// Decide background color of a cell based on its state
    private func backgroundColor(cell: Cell) -> Color {
        if cell.state == .revealed {
            if cell.isMine { return .red }
            else { return .green }
        } else if cell.state == .flagged {
            return .yellow
        } else {
            return .gray
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor(cell: cell))
                .frame(width: 30, height: 30)
            
            // Show mine icon if revealed and the cell is a mine
            if cell.state == .revealed {
                if cell.isMine {
                    Text("X")
                } else {
                    Text(String(cell.adjacentMineCount))
                }
            } else if cell.state == .flagged {
                Text("！")
            }
        }
        .onTapGesture {
            tapAction()
        }
        .onLongPressGesture {
            longPressAction()
        }
        .padding(3)
    }
}
