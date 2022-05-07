//
//  ContentView.swift
//  TetrisGame
//
//  Created by Александр Котляров on 28.04.2022.
//

import SwiftUI

struct GameTetrisView: View {
    
    @ObservedObject var game: TetrisViewModel
    
    var body: some View {
        
        VStack {
            HStack {
                Text("\(game.score.points)")
                Button {
                    game.isPause.toggle()
                    print(game.isPause)
                } label: {
                    game.isPause ? Text("Play") : Text("Pause")
                }

            }
            
            GeometryReader { proxy in
                let l = culcBlockLength(size: proxy.size, column: game.columns, row: game.rows)
                let xoffset = culcOffsetX(width: proxy.size.width, length: l, column: game.columns)
                let yoffset = culcOffsetY(height: proxy.size.height, length: l, row: game.rows)
                ForEach (0..<game.rows, id:\.self) { i in
                    ForEach (0..<game.columns, id:\.self) { j in
                        let path = Path { path in
                                let x = xoffset + l * CGFloat(j)
                                let y = proxy.size.height - yoffset - l * CGFloat(i+1)
                                
                                let rect = CGRect(x: x, y: y, width: l, height: l)
                                path.addRect(rect)
                        }
                        path
                            .fill(getBlockStyle(x: j, y: i))
                            .overlay(path.stroke(getBorderStyle(x: j, y: i), lineWidth: 1))
                        
                    }
                }
                .onTapGesture(perform: game.rotate)
                .gesture(game.getMoveGesture())
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
    
    func getBlockStyle(x: Int, y: Int) -> Color {
        if game.model.field.container[y][x] == .fill {
            return Color(UIColor(named: "Field")!)
        } else if game.model.screen[y][x] == .fill {
            return Color(UIColor(named: "L")!)
        } else if game.model.screen[y][x] == .shadow{
            return Color(UIColor(named: "Shadow")!)
        } else {
            return Color(UIColor(named: "Background")!)
        }
    }
    
    func getBorderStyle(x: Int, y: Int) -> Color {
        if game.model.field.container[y][x] == .fill {
            return Color(UIColor(named: "Field Border")!)
        } else if game.model.screen[y][x] == .fill {
            return Color(UIColor(named: "L Border")!)
        } else if game.model.screen[y][x] == .shadow{
            return Color(UIColor(named: "Shadow Border")!)
        } else {
            return .clear
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameTetrisView(game: TetrisViewModel())
    }
}
