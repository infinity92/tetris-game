//
//  Figure.swift
//  TetrisGame
//
//  Created by Александр Котляров on 04.05.2022.
//

import Foundation



struct Figure {
    var position: (x:Int, y:Int)
    var area: FigureArea
    var coord: [Int: (xx: Int, yy: Int)] = [:]
    var coordCnt = 0
    var gameField: GameField
    var turn: Int = 0 {
        willSet {
            let oldTurn = self.turn
            self.turn = newValue > 3 ? 0 : (newValue < 0 ? 3 : newValue)
            
            guard let chk = checkCollision() else { return }
            if chk == .side {
                let xx = position.x
                let k: Int = (position.x > (gameField.size.columns / 2) ? -1 : +1)
                for _ in 1..<3 {
                    position.x += k
                    if checkCollision() == nil { return }
                }
                position.x = xx
            }
            self.turn = oldTurn
            calcCoord()
        }
    }
    
    init(_ template: TemplatesOfFigure, position: (x:Int, y:Int), field: GameField) {
        self.position = position
        area = FigureArea(template: template.rawValue)
        gameField = field
    }
    
    func put(to screen: inout GameModel.BlockContainer) {
        for i in 0..<coordCnt {
            screen[coord[i]!.yy][coord[i]!.xx] = .fill
        }
    }
    
    func put(to gameField: inout GameField) {
        for i in 0..<coordCnt {
            gameField.container[coord[i]!.yy][coord[i]!.xx] = .fill
        }
    }
    
    mutating func move(dx: Int, dy: Int) -> Bool {
        let oldPosition = position
        position = (position.x + dx, position.y + dy)
        if let chk = checkCollision() {
            position = oldPosition
            calcCoord()
            if chk == .down {
                return false
            }
        }
        return true
    }
    
    mutating func moveLeft() -> Bool {
        return move(dx: -1, dy: 0)
    }
    mutating func moveRight() -> Bool {
        return move(dx: 1, dy: 0)
    }
    mutating func moveDown() -> Bool {
        return move(dx: 0, dy: -1)
    }
    
    mutating func rotate() {
        if (turn + 1 > 3) {
            turn = 0
        } else {
            turn += 1
        }
    }
    
    mutating func checkCollision() -> CollisionType? {
        calcCoord()
        for i in 0..<coordCnt {
            if coord[i]!.xx < 0 || coord[i]!.xx >= gameField.size.columns {
                return .side
            }
        }
        for i in 0..<coordCnt {
            if coord[i]!.yy < 0 || gameField.container[coord[i]!.yy][coord[i]!.xx] == .fill {
                return .down
            }
        }
        
        return nil
    }
    
    mutating func calcCoord() {
        var xx = 0, yy = 0
        coordCnt = 0
        for i in 0..<area.width {
            for j in 0..<area.height {
                if area.area[j][i] == "*" {
                    switch turn {
                    case 1:
                        xx = position.x + (area.height - j - 1)
                        yy = position.y + i
                    case 2:
                        xx = position.x + (area.width - i - 1)
                        yy = position.y + (area.height - j - 1)
                    case 3:
                        xx = position.x + j
                        yy = position.y + (area.height - i - 1) + (area.width-area.height)
                    default:
                        xx = position.x + i; yy = position.y + j
                    }
                    coord[coordCnt] = (xx, yy)
                    coordCnt += 1
                }
            }
        }
    }
}

extension Figure {
    struct FigureArea {
        let width: Int = 4
        let height: Int = 4
        var area: [[String]] = []
        
        init(template: String) {
            var j = 0
            var tmp: [String] = []
            for c in Array(template) {
                tmp.append(String(c))
                j += 1
                if j == width {
                    area.append(tmp)
                    tmp = []
                    j = 0
                }
            }
        }
    }
}


extension Figure {
    enum CollisionType {
        case side
        case down
    }
}


