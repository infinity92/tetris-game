//
//  TetrisGameApp.swift
//  TetrisGame
//
//  Created by Александр Котляров on 28.04.2022.
//

import SwiftUI

@main
struct TetrisGameApp: App {
    var body: some Scene {
        WindowGroup {
            GameTetrisView(game: TetrisViewModel())
        }
    }
}
