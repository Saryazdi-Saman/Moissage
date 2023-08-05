//
//  CircleTimer.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-26.
//

import SwiftUI

struct CircleTimer: View {
    @ObservedObject var vm: MatchingViewModel
//    @State private var rato = vm.timeSelected
    let namespace : Namespace.ID
    @State private var colorOne = #colorLiteral(red: 1,green: 0.5781051517,blue: 0,alpha: 1);
    @State private var colorTwo = #colorLiteral(red: 0.4513868093,green: 0.9930960536,blue: 1, alpha: 1);
    var body: some View {
        VStack{
            ZStack{
                Circle().trim(from: 0, to: 1)
                    .stroke(Color(colorOne).opacity(0.09),
                            style: StrokeStyle(lineWidth: 35, lineCap: .round))
                    .matchedGeometryEffect(id: "path", in: namespace)
                    .frame(width: 280, height: 280)
                
//                Circle().trim(from: 0, to: vm.timeSelected)
//                    .stroke(Color(colorTwo),
//                            style: StrokeStyle(lineWidth: 35, lineCap: .round))
//                    .matchedGeometryEffect(id: "filler", in: namespace)
//                    .frame(width: 280, height: 280)
            }
            .rotationEffect(.init(degrees: -90))
            HStack{
//                if ((Int(vm.timeSelected * vm.availableMinutes))>60) {
//                    Text("\((Int(vm.timeSelected * vm.availableMinutes))/60)")
//                    Text("hr")
//                }
//                Text("\((Int(vm.timeSelected * vm.availableMinutes))%60)")
                Text("min")
            }.font(.system(size: 30, weight: .medium, design: .rounded))
                .padding(.vertical,50)
                
        }
    }
}

struct CircleTimer_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        CircleTimer(vm: MatchingViewModel(),  namespace: namespace)
    }
}
