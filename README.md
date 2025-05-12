
# Minesweeper

This repository contains a modular implementation of the classic **Minesweeper** game using **SwiftUI** and the **MVVM (Model-View-ViewModel)** architecture.

---

## Quick Start

1. Clone this repository:
   
   ```bash
   git clone https://github.com/Evian-Chen/Minesweeper.git
   cd Minesweeper
    ```

2. Open with Xcode:

   ```bash
   open Minesweeper.xcodeproj
   ```

3. Build & Run:

   * Run on iOS Simulator or Mac Catalyst.
   * Choose a grid size and click **"🚀 Build Game"**.
   * Tap a cell to test **first-click-safe mine placement**.

---

## Project Structure

Here's a breakdown of each folder and its role:

```
Minesweeper/
├── Models/
│   ├── Cell.swift             # A single cell on the game board (position, mine, state, flags)
│   ├── Position.swift         # Represents the (row, col) of a cell
│   └── Enums.swift            # Contains CellState: .hidden / .revealed / .flagged
│
├── ViewModels/
│   └── MinesweeperGame.swift  # Core game logic: board generation, mine placement, tap/flag/expand logic
│
├── Views/
│   ├── BoardView.swift        # Renders the 2D grid and handles user interaction
│   ├── CellView.swift         # Visual representation of each cell
│   └── InputFieldView.swift   # Reusable input UI for setting row/col
│
├── ContentView.swift          # A simple usage example of the module
```

---

## Notes

* `ContentView.swift` provides a basic usage demo of how to use the `MinesweeperGame` ViewModel.
* All game logic (including state updates, flag toggling, mine generation, and recursive expansion) is fully encapsulated in `MinesweeperGame.swift`.

---

## Git Branches

The default branch (`main`) contains a base version of the game without flag functionality.

If you'd like to try the **full version**, switch to the feature branch:

```bash
git checkout feature/fullGame
```

To return to the base version:

```bash
git checkout main
```
