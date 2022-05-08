//
//  Menu.swift
//  TetrisGame
//
//  Created by Александр Котляров on 08.05.2022.
//

import SwiftUI

struct Menu: View {
    
    @EnvironmentObject var game: TetrisViewModel
    
    var body: some View {
        VStack {
            Spacer()
            if game.isPause {
                Text("PAUSE")
                    .frame(width: 100, height: 30)
                    .foregroundColor(.black)
            }
            Button {
                game.isMenu = false
                game.newGame()
            } label: {
                Text(game.isPause ? "RESTART" : "NEW GAME")
                    .frame(width: 100, height: 30)
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
