//
//  GameField.swift
//  TetrisGame
//
//  Created by Александр Котляров on 06.05.2022.
//

import Foundation

struct GameField {
    var container: GameModel.BlockContainer
    let size: (columns: Int, rows: Int)
    
    init(by size: (columns:Int, rows: Int)) {
        self.size = size
        container = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
    }
    
    mutating func clear() {
        container = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
    }
    
    func put(to screen: inout GameModel.BlockContainer) {
        for i in 0..<size.columns {
            for j in 0..<size.rows {
                screen[j][i] = container[j][i]
            }
        }
    }
    
    mutating func burning() {
        for j in (0...size.rows-1).reversed() {
            var fillLine = true
            for i in 0..<size.columns {
                if container[j][i] != .fill {
                    fillLine = false
                }
            }
            if fillLine {
                for y in j..<size.rows-1 {
                    container[y] = container[y+1]
                }
                return
            }
        }
    }
}
