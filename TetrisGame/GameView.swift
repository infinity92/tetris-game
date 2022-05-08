//
//  GameView.swift
//  TetrisGame
//
//  Created by Александр Котляров on 08.05.2022.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var  game: TetrisViewModel
    
    var body: some View {
        GeometryReader { proxy in
            let length = culcBlockLength(size: proxy.size, column: game.columns, row: game.rows)
            let xoffset = culcOffsetX(width: proxy.size.width, length: length, column: game.columns)
            let yoffset = culcOffsetY(height: proxy.size.height, length: length, row: game.rows)
            ForEach (0..<game.rows, id:\.self) { i in
                ForEach (0..<game.columns, id:\.self) { j in
                    let x = xoffset + length * CGFloat(j)
                    let y = proxy.size.height - yoffset - length * CGFloat(i+1)
                    
                    BlockView(x: x, y: y, length: length)
                        .opacity(getBlockOpacity(x: j, y: i))
                }
            }
            
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
    
    func getBlockOpacity(x: Int, y: Int) -> Double {
        if game.model.field.container[y][x] == .fill {
            return 1
        } else if game.model.screen[y][x] == .fill {
            return 1
        } else if game.model.screen[y][x] == .shadow{
            return 0.3
        } else {
            return 0.1
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
