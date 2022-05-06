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
    var field: GameField
    
    var figureFactory: (GameField, (columns:Int, rows:Int)) -> Figure
    
    
    
    init(_ rows: Int,
         _ columns: Int,
         _ figureFactory: @escaping (GameField, (columns:Int, rows:Int)) -> Figure,
         _ fieldFactory: @escaping ((columns: Int, rows: Int)) -> GameField) {
        size = (columns: columns, rows: rows)
        screen = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
        field = fieldFactory(size)
        self.figureFactory = figureFactory
        figure = self.figureFactory(field, size)
        
    }
    
    mutating func clearMap() {
        screen = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
    }
    
    mutating func move() {
        if !figure.moveDown() {
            figure.put(to: &field)
            figure = self.figureFactory(field, size)
            if figure.checkCollision() != nil {
                field.clear()
            }
        }
        field.burning()
    }
    
    mutating func update() {
        clearMap()
        field.put(to: &screen)
        figure.put(to: &screen)
    }
}

enum BlockState {
    case empty, fill
}
