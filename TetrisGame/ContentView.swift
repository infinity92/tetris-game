//
//  ContentView.swift
//  TetrisGame
//
//  Created by Александр Котляров on 28.04.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var game: TetrisViewModel
    
    var body: some View {
        
        GeometryReader { proxy in
            let l = culcBlockLength(size: proxy.size, column: game.columns, row: game.rows)
            let xoffset = culcOffsetX(width: proxy.size.width, length: l, column: game.columns)
            let yoffset = culcOffsetY(height: proxy.size.height, length: l, row: game.rows)
            ForEach (0..<game.rows, id:\.self) { i in
                ForEach (0..<game.columns, id:\.self) { j in
                    Path { path in
                            let x = xoffset + l * CGFloat(j)
                            let y = proxy.size.height - yoffset - l * CGFloat(i+1)
                            
                            let rect = CGRect(x: x, y: y, width: l, height: l)
                            path.addRect(rect)
                    }
                    .fill(getBlockStyle(x: j, y: i))
                }
            }
            .onTapGesture {
                game.rotate()
            }
            .gesture(game.getMoveGesture())
        }
        
    }
    
    
    func culcOffsetX(width: CGFloat, length: CGFloat, column: Int) -> CGFloat {
        return (width - length * CGFloat(column))/2
    }
    
    func culcOffsetY(height: CGFloat, length: CGFloat, row: Int) -> CGFloat {
        return (height - length * CGFloat(row))/2
    }
    
    func culcBlockLength(size: CGSize, column: Int, row: Int) -> CGFloat {
        return  min(size.width / CGFloat(column), size.height / CGFloat(row))
    }
    
    func getBlockStyle(x: Int, y: Int) -> Color {
        return game.model.screen[y][x] != .fill && game.model.gameField.container[y][x] != .fill ? Color.gray : Color.blue
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: TetrisViewModel())
    }
}
