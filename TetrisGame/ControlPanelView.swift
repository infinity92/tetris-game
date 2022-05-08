//
//  ControlPanelView.swift
//  TetrisGame
//
//  Created by Александр Котляров on 08.05.2022.
//

import SwiftUI

struct ControlPanelView: View {
    @EnvironmentObject var game: TetrisViewModel
    
    @State var sizeButton:CGFloat = 60
    
    var body: some View {
        HStack {
            VStack {
                HStack{
                    Button {
                        _ = game.model.figure.moveLeft()
                        game.updateScreen()
                    } label: {
                        getYellowBottom(sysImg: "arrowtriangle.left.fill")
                    }
                    Spacer(minLength: 20)
                    Button {
                        _ = game.model.figure.moveRight()
                        game.updateScreen()
                    } label: {
                        getYellowBottom(sysImg: "arrowtriangle.right.fill")
                    }

                }
                
                Button {
                    _ = game.model.figure.moveDown()
                    game.updateScreen()
                } label: {
                    getYellowBottom(sysImg: "arrowtriangle.down.fill")
                   
                }
                
            }
            Spacer()
            Button {
                game.model.figure.rotate()
                game.updateScreen()
            } label: {
                getBlueBottom(sysImg: "arrow.counterclockwise")
            }
            .padding(.top, sizeButton)
            Button {
                game.model.figure.fastMoveDown()
                game.updateScreen()
            } label: {
                getBlueBottom(sysImg: "arrow.down.to.line")
            }
            .padding(.bottom, sizeButton)
        }
    }
    
    func getYellowBottom(sysImg: String) -> some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.565, green: 0.561, blue: 0.557))
                .frame(width: sizeButton+10, height: sizeButton+10)
            Circle()
                .fill(.yellow)
                .frame(width: sizeButton, height: sizeButton)
            Image(systemName: sysImg)
                .resizable()
                .foregroundColor(Color(red: 0.907, green: 0.55, blue: 0.087))
                .frame(width: 20, height: 20)
                //.padding(.top, 5)
        }
    }
    
    func getBlueBottom(sysImg: String) -> some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.565, green: 0.561, blue: 0.557))
                .frame(width: sizeButton+10, height: sizeButton+10)
            Circle()
                .fill(Color(red: 0.192, green: 0.64, blue: 0.887))
                .frame(width: sizeButton, height: sizeButton)
            
            Image(systemName: sysImg)
                .resizable()
                .foregroundColor(Color(red: 0.08, green: 0.327, blue: 0.484))
                .frame(width: 25, height: 25)
            
        }
    }
}

struct ControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanelView()
            .frame(width: 200, height: 100)
    }
}
