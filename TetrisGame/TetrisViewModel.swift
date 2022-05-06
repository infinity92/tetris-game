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
    
    @Published var model = GameModel(38, 20) { gameField, size in
        Figure(TemplatesOfFigure.allCases.randomElement()!, position: ( Int(size.columns/2), size.rows - 5), field: gameField)
    } _ : { size in
        var gameField = GameField(by: size)
        var figure = Figure(.q, position: (0-1, 0-1), field: gameField)
        figure.put(to: &gameField)
        return gameField
    }
    
    var timer: Timer?
    var speed: Double
    
    init() {
        speed = 0.5
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) {timer in
            self.model.move()
            self.model.update()
        }
    }
    
    func updateScreen() {
        self.model.update()
    }
    
    func rotate() {
        self.model.figure.rotate()
        self.model.update()
    }
    
    func getMoveGesture() -> some Gesture {
        return DragGesture()
        .onChanged(onMoveChanged(value:))
        .onEnded(onMoveEnded(_:))
    }
    
    func onMoveChanged(value: DragGesture.Value) {
        guard let start = lastMoveLocation else {
            lastMoveLocation = value.location
            return
        }
        
        let xDiff = value.location.x - start.x
        if xDiff > 5 {
            _ = model.figure.moveRight()
            return
        }
        if xDiff < -5 {
            _ = model.figure.moveLeft()
            return
        }
        
        let yDiff = value.location.y - start.y
        if yDiff > 5 {
            _ = model.figure.moveDown()
            return
        }
        if yDiff < -5 {
        }
        self.model.update()
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
