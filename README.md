# Minesweeper

This repository contains a modular implementation of the classic **Minesweeper** game using **SwiftUI** and the **MVVM (Model-View-ViewModel)** architecture.

---

## Quick Start

1. Clone this repository:
   
  ```bash
  git clone https://github.com/Evian-Chen/Minesweeper.git
  cd minesweeper-swiftui
  ```

2. Open with Xcode:

  ```bash
  open Minesweeper.xcodeproj
  ```

3. Build & Run:

   * Run on iOS Simulator or Mac Catalyst.
   * Choose grid size and click "🚀 Build Game".
   * Tap a cell to test **first-click-safe mine placement**.

---

## Project Structure

Here's a breakdown of each folder and its role:

```
Minesweeper/
├── Models/
│   ├── Cell.swift             # A single cell on the game board (position, mine, state)
│   ├── Position.swift         # Represents the (row, col) of a cell
│   └── Enums.swift            # Currently only contains CellState: .hidden / .revealed / .flagged
│
├── ViewModels/
│   └── MinesweeperGame.swift  # Core game logic: board generation, mine placement, tap logic
│
├── Views/
│   ├── BoardView.swift        # Renders the 2D grid and handles interactions
│   ├── CellView.swift         # Visual representation of an individual cell
│   └── InputFieldView.swift   # Reusable input UI for setting row/col
│
├── ContentView.swift      # A simple usage example of the module
```

---

## Notes

* `ContentView.swift` provides a basic usage demo of the module `MinesweeperGame`.
* The core logic is encapsulated in `MinesweeperGame.swift`.

