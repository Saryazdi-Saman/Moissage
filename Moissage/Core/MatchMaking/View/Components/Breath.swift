//
//  Braeth.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-27.
//

import SwiftUI

struct Breath: View {
    @ObservedObject var vm : MatchingViewModel
    @State private var rBreath = false
    @State private var lBreath = false
    @State private var mrBreath = false
    @State private var mlBreath = false
    @State private var showShadow = false
    @State private var showRightStroke = false
    @State private var showLeftStroke = false
    @State private var petalWidth : CGFloat = 60
    
    var body: some View {
        VStack{
            ZStack {
                Image("flower").resizable()
                    .scaledToFit().frame(width: petalWidth)  // Middle
                    .rotationEffect(.degrees(0), anchor: .bottom)
                
                Image("flower").resizable()
                    .scaledToFit().frame(width: petalWidth)  // Middle left
                Image("flower").resizable()
                    .scaledToFit().frame(width: petalWidth)  // Left
                    .rotationEffect(.degrees( !vm.change ? -25 : -5), anchor: .bottom)
//                    .animation(Animation.easeInOut(duration: 2))
                
                Image("flower").resizable()
                    .scaledToFit().frame(width: petalWidth)  // Middle right
                Image("flower").resizable()
                    .scaledToFit().frame(width: petalWidth)  // Right
                    .rotationEffect(.degrees( !vm.change ? 25 : 5), anchor: .bottom)
//                    .animation(Animation.easeInOut(duration: 2))
                
                Image("flower").resizable()
                    .scaledToFit().frame(width: petalWidth)  // Left
                    .rotationEffect(.degrees( !vm.change ? -50 : -10), anchor: .bottom)
//                    .animation(Animation.easeInOut(duration: 2))
                
                Image("flower").resizable()
                    .scaledToFit().frame(width: petalWidth)  // Right
                    .rotationEffect(.degrees( !vm.change ? 50 : 10), anchor: .bottom)
//                    .animation(Animation.easeInOut(duration: 2))
                
            }.shadow(radius: !vm.change ? 20 : 0)
                .hueRotation(Angle(degrees: !vm.change ? 0 : 180))
//                .animation(Animation.easeInOut(duration: 2))
        }
    }
}

struct Braeth_Previews: PreviewProvider {
    static var previews: some View {
        Breath(vm: MatchingViewModel())
    }
}
