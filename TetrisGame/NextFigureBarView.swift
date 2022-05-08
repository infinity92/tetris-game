//
//  NextFigureBarView.swift
//  TetrisGame
//
//  Created by Александр Котляров on 08.05.2022.
//

import SwiftUI

struct NextFigureBarView: View {
    
    //@State var length: CGFloat = 10
    @Binding var figure: Figure
    
    var body: some View {
        GeometryReader { proxy in
            let length = min(proxy.size.width / CGFloat(figure.area.width), proxy.size.height / CGFloat(figure.area.height))
            ForEach (0..<figure.area.height, id:\.self) { i in
                ForEach (0..<figure.area.width, id:\.self) { j in
                    
                    let x = length * CGFloat(j)
                    let y = proxy.size.height - length * CGFloat(i+1)
                    if figure.area.container[j][i] == "*" {
                        BlockView(x: x, y: y, length: length)
                            .opacity(1)
                    } else {
                        BlockView(x: x, y: y, length: length)
                            .opacity(0)
                    }
                }
            }
        }
    }
}
