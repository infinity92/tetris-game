//
//  StatusBarView.swift
//  TetrisGame
//
//  Created by Александр Котляров on 08.05.2022.
//

import SwiftUI

struct StatusBarView: View {
    
    @EnvironmentObject var game: TetrisViewModel
    
    @State var sizePauseButton: CGFloat = 30
    
    var body: some View {
        VStack {
            
            Text("Level")
                .padding(.top, 10)
            Text("\(game.level)")
            
            Text("Score")
                .padding(.top, 10)
            Text("\(game.score.points)")
            
            Text("Next")
                .padding(.top, 10)
            ZStack {
                Rectangle()
                    .fill(.gray)
                    .opacity(0.4)
                    .frame(width: 70, height: 70)
                NextFigureBarView(figure: $game.model.nextFigure)
                    .frame(width: 50, height: 50)
            }
            .padding(.top, 0)
            Spacer()
            
            Button {
                game.isPause.toggle()
            } label: {
                if game.isPause {
                    Image(systemName: "play.circle")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: sizePauseButton, height: sizePauseButton)
                } else {
                    Image(systemName: "pause.circle")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: sizePauseButton, height: sizePauseButton)
                }
                
            }
            .padding(.bottom, 20)
        }
        
    }
}

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView()
    }
}
