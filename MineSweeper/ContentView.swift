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

class Cell: ObservableObject, Identifiable {
    var id = UUID()
    var pos: Position
    var isMine: Bool
    @Published var state: cellState
    
    init(pos: Position, isMine: Bool, state: cellState) {
        self.pos = pos
        self.isMine = isMine
        self.state = state
    }
}

struct Position: Hashable {
    let row: Int
    let col: Int
}

final class MineSweeper: ObservableObject {
    var row: Int
    var col: Int
    var mineCount: Int
    private var minePos: Set<Position> = []
    @Published var gameBoard: [Cell] = []
    
    // 初次宣告時先設定是0，等使用者有長寬的資料時，呼叫setUpboard建立資訊
    init() {
        self.row = 0
        self.col = 0
        self.mineCount = 0
    }
    
    // 用於初始化整張地圖
    func initWithData(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.mineCount = 5 // 先都設定是五個
        self.generateBoard()
    }
    
    func generateBoard() {
        for i in 0 ..< row * col {
            self.gameBoard.append(Cell(pos: Position(row: i / row, col: i % col),
                                       isMine: false,
                                       state: .hidden))
        }
    }
    
    // 使用者對初始化完畢後地圖的第一次點擊
    func generateMine(firstPos: Position) {
        self.minePos.removeAll()  // make sure it's empty
        
        var pos = Position(row: Int.random(in: 0 ..< self.row), col: Int.random(in: 0 ..< self.col))
        for _ in 0 ..< self.mineCount {
            while (pos == firstPos) {
                pos = Position(row: Int.random(in: 0 ..< self.row), col: Int.random(in: 0 ..< self.col))
            }
            self.minePos.insert(pos)
            self.gameBoard[pos.row * self.col + pos.col].isMine = true
            pos = Position(row: Int.random(in: 0 ..< self.row), col: Int.random(in: 0 ..< self.col))
        }
    }
    
    // 使用者點擊的時候，從UI端傳進一個位置，針對這個位置更新資料，應該要可以擴增說：如果右鍵點擊，有不一樣的更新
    func updateBoard(pos: Position) {
        let index = pos.row * self.col + pos.col
        if self.gameBoard[index].isMine {
            // game over, do sth
        } else {
            self.gameBoard[index].state = .revealed
        }
    }
    
    func getMinePos() -> Set<Position> {
        // test
        for po in minePos {
            print("mine at \(po.row), \(po.col)")
        }
        return self.minePos
    }
    
    func getBoard() -> [Cell] {
        return self.gameBoard
    }
}

struct ContentView: View {
    @State var row = 0
    @State var col = 0
    @State var buildGame = false
    @State var firstClick = true
    @StateObject var mineSweeper = MineSweeper()
    
    // 顯示單格 Cell
    @ViewBuilder
    func CellView(@ObservedObject cell: Cell) -> some View {
        Button {
            if firstClick {
                mineSweeper.generateMine(firstPos: cell.pos)
                firstClick = false
                mineSweeper.getMinePos()
            }
            mineSweeper.updateBoard(pos: cell.pos)
            if !cell.isMine {
                cell.state = .revealed
            }
        } label: {
            ZStack {
                Rectangle()
                    .fill(cell.state == .revealed ? .blue : .gray)
                    .frame(width: 25, height: 25)
                
                if cell.state == .revealed && cell.isMine {
                    Text("X").bold()
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            // Input row/col
            HStack() {
                Text("ROW: ")
                    .padding(.leading)
                TextField("Row: ", value: $row, formatter: NumberFormatter())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.trailing)
                
                Text("COL: ")
                    .padding(.leading)
                TextField("Col: ", value: $col, formatter: NumberFormatter())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.trailing)
            }
            .padding(.bottom)
            
            // Buttons
            HStack {
                Button {
                    mineSweeper.initWithData(row: row, col: col)
                    buildGame = true
                    firstClick = true
                } label: {
                    Text("build")
                        .padding()
                        .frame(width: 300)
                        .background(buildGame ? .gray.opacity(0.4) : .green.opacity(0.4))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Button {
                    buildGame = false
                } label: {
                    Text("reset")
                        .padding()
                        .frame(width: 300)
                        .background(buildGame ? .green.opacity(0.4) : .red.opacity(0.4))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            
            // 建立遊戲格子
            if buildGame {
                let grid = mineSweeper.getBoard()
                VStack(spacing: 2) {
                    ForEach(0..<row, id: \.self) { r in
                        HStack(spacing: 2) {
                            ForEach(0..<col, id: \.self) { c in
                                let index = r * col + c
                                if index < grid.count {
                                    CellView(cell: grid[index])
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
        }
        .padding()
    }
}



//
//
//
//class Cell: ObservableObject, Identifiable {
//    var id = UUID()
//
//    var curIndex: Int
//    var rowIndex: Int
//    var colIndex: Int
//    var isMine: Bool = false
//    @Published var state: cellState = .hidden
//
//    init(curIndex: Int, rowIndex: Int, colIndex: Int) {
//        self.curIndex = curIndex
//        self.rowIndex = rowIndex
//        self.colIndex = colIndex
//    }
//}
//
//class GameBoard: ObservableObject {
//    private var row: Int
//    private var col: Int
//    private var totalCell: Int
//    private var mine: Int
//    private var minePos: [(Int, Int)]
//
//    @Published var gameBoard: [Cell]
//
//    init() {
//        self.row = 0
//        self.col = 0
//        self.totalCell = 0
//        self.mine = 0
//        self.minePos = [(-1, -1)]
//        self.gameBoard = []
//    }
//
//    // after gotten row/col information, setup the board
//    func setUpBoard(row: Int, col: Int) {
//        self.row = row
//        self.col = col
//        self.totalCell = row * col
//        self.mine = Int((Double(self.totalCell) * 0.1).rounded()) + 1 // avoid zero mine
//        self.gameBoard = []  // in case reset
//        for i in 0 ..< self.totalCell {
//            gameBoard.append(Cell(curIndex: i, rowIndex: i / self.col, colIndex: i % self.col))
//        }
//    }
//
//    // UI call this function when it meets the first click of this board
//    // input row and col
//    func firstClick(row: Int, col: Int) {
//        // make sure it's claer before adding mines
//        self.minePos.removeAll()
//
//        // generate mines
//        var mineRow = Int.random(in: 0 ..< self.row)
//        var mineCol = Int.random(in: 0 ..< self.col)
//
//        for _ in 0 ..< self.mine {
//            while (mineRow == row && mineCol == col) {
//                mineRow = Int.random(in: 0 ..< self.row)
//                mineCol = Int.random(in: 0 ..< self.col)
//            }
//
//            self.gameBoard[row * self.row + col].isMine = true
//            self.minePos.append( (mineRow, mineCol) )
//
//            mineRow = Int.random(in: 0 ..< self.row)
//            mineCol = Int.random(in: 0 ..< self.col)
//        }
//
//        // test
//        for pos in minePos {
//            print("Mine at row \(pos.0), col \(pos.1)")
//        }
//        print("mine: \(self.mine)\n")
//
//        for c in self.gameBoard {
//            if c.isMine {
//                print("there's a mine")
//            }
//        }
//    }
//
//    // getter function, this function returns all mine positions
//    func getMinePos() -> [(Int, Int)] {
//        return self.minePos
//    }
//
//    // return the view of gameboard
//    @ViewBuilder
//    func makeBoardView() -> some View {
//        LazyVStack(spacing: 2) {
//            ForEach(0 ..< self.row, id: \.self) { i in
//                HStack(spacing: 2) {
//                    ForEach(0 ..< self.col, id: \.self) { j in
//                        let index = i * self.col + j
//                        if index < self.gameBoard.count {
//                            cellView(cell: self.gameBoard[index])
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct cellView: View {
//    @ObservedObject var cell: Cell
//
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(cell.state == .revealed ? .gray : .blue)
//                .frame(width: 25, height: 25)
//
//            if cell.state == .revealed && cell.isMine {
//                Text("X").bold()
//            }
//        }
//        .padding(5)
//        .onTapGesture {
//            cell.state = .revealed
//        }
//    }
//}
//
//
