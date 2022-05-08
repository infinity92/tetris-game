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
    //var nextFigure: Figure
    var screen: BlockContainer
    var field: GameField
    var makeFigure: (GameField, (columns:Int, rows:Int)) -> Figure
    var onFinishGameEvent: (() -> Void)?
    var onFigureFinishMoveDownEvent: ((Figure)->Void)?
    var onBurningLineEvent: ((Int) -> Void)? {
        get {
            field.onBurningLineEvent
        }
        set {
            field.onBurningLineEvent = newValue
        }
    }
    
    init(_ rows: Int,
         _ columns: Int,
         _ figureFactory: @escaping (GameField, (columns:Int, rows:Int)) -> Figure,
         _ fieldFactory: @escaping ((columns: Int, rows: Int)) -> GameField) {
        size = (columns: columns, rows: rows)
        screen = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
        field = fieldFactory(size)
        self.makeFigure = figureFactory
        //nextFigure = self.makeFigure(field, size)
        figure = self.makeFigure(field, size)
    }
    
    mutating func clearMap() {
        screen = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
    }
    
    mutating func move() {
        if !figure.moveDown() {
            figure.put(to: &field)
            if let finishMoveDownEvent = onFigureFinishMoveDownEvent {
                finishMoveDownEvent(figure)
            }
            figure = self.makeFigure(field, size)
            //nextFigure = self.makeFigure(field, size)
            if figure.checkCollision() != nil {
                field.clear()
                if let endGame = onFinishGameEvent {
                    endGame()
                }
            }
        }
        field.burning()
        figure.gameField = field
    }
    
    mutating func update() {
        clearMap()
        field.put(to: &screen)
        figure.put(to: &screen)
    }
}

enum BlockState {
    case empty, fill, shadow
}


