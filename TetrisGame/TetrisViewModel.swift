//
//  TetrisViewModel.swift
//  TetrisGame
//
//  Created by Александр Котляров on 28.04.2022.
//

import Foundation
import SwiftUI

class TetrisViewModel: ObservableObject {
    
    var columns: Int {
        model.size.columns
    }
    var rows: Int {
        model.size.rows
    }
    var lastMoveLocation: CGPoint?
    var timer: Timer?
    var speed: Double
    @Published var isPause: Bool = false {
        didSet {
            if isPause {
                timer?.invalidate()
            } else {
                play()
            }
        }
    }
    
    @Published var score: Score = Score()
    @Published var model: GameModel
    
    init() {
        self.model = GameModel(38, 20, TetrisViewModel.makeFigure, TetrisViewModel.makeGameField)
        speed = 0.5
        play()
        self.model.onFinishGameEvent = onEndGame
        self.model.onFigureFinishMoveDownEvent = onFinishMoveDownEvent
        self.model.onBurningLineEvent = onBurningLineEvent
    }
    
    static func makeFigure(on gameField: GameField, and size: (columns:Int, rows:Int)) -> Figure {
        return Figure(TemplatesOfFigure.allCases.randomElement()!, position: ( Int(size.columns/2), size.rows - 5), field: gameField)
    }
    
    func play() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            self.model.move()
            self.updateScreen()
        }
    }
    
    static func makeGameField(by size: (columns:Int, rows:Int)) -> GameField {
        var gameField = GameField(by: size)
        
        /*var figure = Figure(.q, position: (0-1, 0-1), field: gameField)
        figure.put(to: &gameField)
        
        figure = Figure(.q, position: (0-1+2, 0-1), field: gameField)
        figure.put(to: &gameField)
        
        figure = Figure(.q, position: (0-1+4, 0-1), field: gameField)
        figure.put(to: &gameField)
        
        figure = Figure(.q, position: (0-1+6, 0-1), field: gameField)
        figure.put(to: &gameField)
        
        figure = Figure(.q, position: (0-1+8, 0-1), field: gameField)
        figure.put(to: &gameField)
        
        figure = Figure(.q, position: (0-1+10, 0-1), field: gameField)
        figure.put(to: &gameField)
        
        figure = Figure(.q, position: (0-1+12, 0-1), field: gameField)
        figure.put(to: &gameField)
        
        figure = Figure(.q, position: (0-1+14, 0-1), field: gameField)
        figure.put(to: &gameField)
        
        figure = Figure(.q, position: (0-1+16, 0-1), field: gameField)
        figure.put(to: &gameField)*/
        
        return gameField
    }
    
    func onEndGame() {
        timer?.invalidate()
        score.reset()
        print("The End")
    }
    
    func updateScreen() {
        self.model.update()
    }
    
    func rotate() {
        if isPause {
            return
        }
        self.model.figure.rotate()
        self.updateScreen()
    }
    
    func getMoveGesture() -> some Gesture {
        return DragGesture()
        .onChanged(onMoveChanged(value:))
        .onEnded(onMoveEnded(_:))
    }
    
    func onMoveChanged(value: DragGesture.Value) {
        if isPause {
            return
        }
        guard let start = lastMoveLocation else {
            lastMoveLocation = value.location
            return
        }
        
        let lenBlock:CGFloat = 19.22
        
        let xDiff = value.location.x - start.x
        if xDiff >= 1 * lenBlock {
            _ = model.figure.moveRight()
            self.updateScreen()
            return
        }
        if xDiff <= -1 * lenBlock {
            _ = model.figure.moveLeft()
            self.updateScreen()
            return
        }
        
        let yDiff = value.location.y - start.y
        if yDiff > 1 * lenBlock {
            _ = model.figure.moveDown()
            self.updateScreen()
            return
        }
        if yDiff < -3 {
            model.figure.fastMoveDown()
            self.updateScreen()
            return
        }
    }
    
    func onFinishMoveDownEvent(_ figure: Figure) {
        score.add(points: 10)
    }
    
    func onBurningLineEvent(_ number: Int) {
        score.add(points: 50)
    }
    
    func onMoveEnded(_:DragGesture.Value) {
        lastMoveLocation = nil
    }
}

enum TemplatesOfFigure: String, CaseIterable {
    case q = ".....**..**....."
    case l = "....****........"
    case t = ".....***.*......"
    case s = ".....**.**......"
    case g = "....***.*......."
}
