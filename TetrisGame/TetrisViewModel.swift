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
            isMenu = isPause
        }
    }
    @Published var isStarted: Bool {
        didSet {
            if !isStarted {
                isMenu = true
            }
        }
    }
    @Published var isMenu = true
    @Published var score: Score = Score()
    @Published var model: GameModel
    @Published var level: Int = 1
    
    init() {
        self.model = GameModel(20, 10, TetrisViewModel.makeFigure, TetrisViewModel.makeGameField)
        speed = 0.9
        isStarted = false
        self.model.onFinishGameEvent = onEndGame
        self.model.onFigureFinishMoveDownEvent = onFinishMoveDownEvent
        self.model.onBurningLineEvent = onBurningLineEvent
        
        
    }
    
    static func makeFigure(on gameField: GameField, and size: (columns:Int, rows:Int)) -> Figure {
        return Figure(FigureTemplates.allCases.randomElement()!, position: ( Int(size.columns/2), size.rows - 5), field: gameField)
    }
    
    func newGame() {
//        model.field.clear()
//        model.clearMap()
//        score.reset()
//        play()
        
        self.model = GameModel(20, 10, TetrisViewModel.makeFigure, TetrisViewModel.makeGameField)
        speed = 0.9
        isStarted = true
        self.model.onFinishGameEvent = onEndGame
        self.model.onFigureFinishMoveDownEvent = onFinishMoveDownEvent
        self.model.onBurningLineEvent = onBurningLineEvent
        level = 1
        score.reset()
        play()
        
    }
    
    func play() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            self.model.move()
            self.updateScreen()
        }
    }
    
    static func makeGameField(by size: (columns:Int, rows:Int)) -> GameField {
        return GameField(by: size)
    }
    
    func onEndGame() {
        isStarted = false
    }
    
    func updateScreen() {
        self.model.update()
    }
    
    func rotate() {
        if isPause {
            return
        }
        self.model.figure.rotate()
    }
    
    func onFinishMoveDownEvent(_ figure: Figure) {
        //score.add(points: 10)
    }
    
    func onBurningLineEvent(_ number: Int) {
        score.add(points: 50)
        if score.points >= 500 * level {
            level += 1
            speed *= 0.8
            play()
        }
    }

}
