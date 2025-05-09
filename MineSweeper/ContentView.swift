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

struct Position: Hashable {
    let row: Int
    let col: Int
}

class Cell: ObservableObject, Identifiable {
    var id = UUID()
    var pos: Position
    @Published var isMine: Bool
    @Published var state: cellState
    
    init(pos: Position, isMine: Bool, state: cellState) {
        self.pos = pos
        self.isMine = isMine
        self.state = state
    }
}

// for game setting logic
class MineSweeper: ObservableObject {
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
    func initSize(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.mineCount = Int.random(in: 0 ..< row)
        self.generateBoard()
    }
    
    // 產生所有的 Cell Objc
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
        
        while self.minePos.count < self.mineCount {
            let ranR = Int.random(in: 0 ..< self.row)
            let ranC = Int.random(in: 0 ..< self.col)
            let pos = Position(row: ranR, col: ranC)
            if (pos != firstPos) {
                self.minePos.insert(pos)
                self.gameBoard[ranR * self.col + ranC].isMine = true
            }
        }
    }
    
    // 使用者點擊的時候，從UI端傳進一個位置，針對這個位置更新資料，應該要可以擴增說：如果右鍵點擊，有不一樣的更新
    func updateBoard(pos: Position, isFirstClick: Bool) {
        let index = pos.row * self.col + pos.col
        
        if isFirstClick {
            self.generateMine(firstPos: pos)
            
            // test
            var _ = self.getMinePos()
        } else if self.gameBoard[index].isMine {
            // game over, do sth
        }
        
        self.gameBoard[index].state = .revealed
    }
    
    // UI 端選擇重設遊戲
    func resetGame() {
        self.gameBoard.removeAll()
        self.row = 0
        self.col = 0
        self.mineCount = 0
    }
    
    func getMinePos() -> Set<Position> {
        // test
        for po in minePos {
            print("mine at \(po.row), \(po.col)")
        }
        print("===")
        return self.minePos
    }
    
    func getBoard() -> [Cell] {
        return self.gameBoard
    }
}

struct CellView: View {
    @ObservedObject var cell: Cell
    let tapAction: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(cell.state == .revealed ? Color.green : Color.gray)
                .frame(width: 30, height: 30)
            
            if cell.state == .revealed && cell.isMine {
                Text("X")
            }
        }
        .onTapGesture {
            tapAction()
        }
    }
}

struct BoardView: View {
    @ObservedObject var mineSweeper: MineSweeper
    @Binding var isFirstClick: Bool
    
    var body: some View {
        VStack {
            ForEach(0 ..< mineSweeper.row, id: \.self) { i in
                HStack {
                    ForEach(0 ..< mineSweeper.col, id: \.self) { j in
                        let index = i * mineSweeper.col + j
                        CellView(cell: mineSweeper.gameBoard[index]) {
                            mineSweeper.updateBoard(pos: Position(row: i, col: j), isFirstClick: isFirstClick)
                            isFirstClick = false
                        } // CellView
                    } // j
                } // HStack
            } // i
        } // VStack
        
    }
}

struct ContentView: View {
    @State var row = 5
    @State var col = 5
    @State var isStarted = false
    @State var isFirstClick = true

    @StateObject var mineSweeper = MineSweeper()

    var body: some View {
        VStack {
            rowColInputField(row: $row, col: $col)

            Button("Build Game") {
                mineSweeper.initSize(row: row, col: col)
                isStarted = true
                isFirstClick = true
            }
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(8)

            if isStarted {
                BoardView(mineSweeper: mineSweeper, isFirstClick: $isFirstClick)

                Button("Reset Game") {
                    isStarted = false
                    isFirstClick = false
                    mineSweeper.resetGame()
                }
                .padding()
            }
        }
        .padding()
    }
}


struct rowColInputField: View {
    @Binding var row: Int
    @Binding var col: Int
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
