//
//  SwiftUIView.swift
//  TetrisGame
//
//  Created by Александр Котляров on 08.05.2022.
//

import SwiftUI

struct BlockView: View {
    @State var x: CGFloat
    @State var y: CGFloat
    @State var length: CGFloat
    var body: some View {
        let l = length - length/10/2
        let subLength: CGFloat = l/1.9
        let subX: CGFloat = x+(l - subLength)/2
        let subY: CGFloat = y+(l - subLength)/2
        let path = Path { path in
            let rect = CGRect(x: x, y: y, width: l, height: l)
            path.addRect(rect)
        }
        
        path
            .stroke(.black, lineWidth: length/10)
            .overlay {
                Path { path in
                    let rect = CGRect(x: subX, y: subY, width: subLength, height: subLength)
                    path.addRect(rect)
                }
                .fill(.black)
            }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            BlockView(x: 10, y: 10, length: 50)
            BlockView(x: 10, y: 10, length: 50)
        }
    }
}
