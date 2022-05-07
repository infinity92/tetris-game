//
//  Score.swift
//  TetrisGame
//
//  Created by Александр Котляров on 06.05.2022.
//

import Foundation

struct Score {
    private(set) var points: Int = 0
    
    init(points: Int = 0) {
        self.points = points
    }
    
    mutating func add(points: Int) {
        self.points += points
    }
    
    mutating func reset() {
        points = 0
    }
}
