//
//  GameField.swift
//  TetrisGame
//
//  Created by Александр Котляров on 28.04.2022.
//

import Foundation

struct GameModel {
    typealias BlockContainer = [[BlockState]]
    
    let size: (columns:Int, rows: Int)
    var figure: Figure
    var screen: BlockContainer
    var gameField: GameField
    
    var figureFactory: (GameField, (columns:Int, rows:Int)) -> Figure
    
    
    
    init(_ rows: Int, _ columns: Int, _ figureFactory: @escaping (GameField, (columns:Int, rows:Int)) -> Figure) {
        size = (columns: columns, rows: rows)
        screen = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
        gameField = GameField(by: size)
        self.figureFactory = figureFactory
        figure = self.figureFactory(gameField, size)
        
    }
    
    mutating func clearMap() {
        screen = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
    }
    
    mutating func move() {
        if !figure.moveDown() {
            figure.put(to: &gameField)
            figure = self.figureFactory(gameField, size)
            if figure.checkCollision() != nil {
                gameField.clear()
            }
        }
        gameField.burning()
    }
}


struct GameField {
    var container: GameModel.BlockContainer
    let size: (columns:Int, rows: Int)
    
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

enum BlockState {
    case empty, fill
}
