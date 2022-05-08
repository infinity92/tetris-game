//
//  ContentView.swift
//  TetrisGame
//
//  Created by Александр Котляров on 28.04.2022.
//

import SwiftUI

struct GameTetrisView: View {
    
    @EnvironmentObject var game: TetrisViewModel
    
    var body: some View {
        
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("TETRIS").fontWeight(.bold).foregroundColor(.gray)
                ZStack {
                    Rectangle().fill(.gray).frame(width: 330, height: 414)
                    HStack {
                        GameView()
                            .frame(width: 200, height: 400)
                            .padding(0)
                        Rectangle().fill(.black).frame(width: 1, height: 400)
                            .padding(0)
                        StatusBarView()
                            .frame(width: 100, height: 400)
                    }
                    .background(Color(UIColor(named: "Background")!))
                }
                
                ControlPanelView()
                    .frame(width: 200, height: 100)
                    .padding(.top, 50)
                Spacer()
            }
            Spacer()
        }
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.861))
    }
}


