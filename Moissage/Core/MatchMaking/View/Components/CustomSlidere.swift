//
//  CustomSlidere.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-26.
//

import SwiftUI

struct CustomSlidere: View {
    @ObservedObject var vm: MatchingViewModel
    @State var maxWidth : CGFloat = UIScreen.main.bounds.width * 0.8
    
    @State var selectedTime = Date()
    @State private var futureTime = Date()
    private let closingTime = Calendar.current.date(
      bySettingHour: 23,
      minute: 59,
      second: 59,
      of: Date())!
    init(vm: MatchingViewModel){
        self.vm = vm
        if futureTime>closingTime {
            futureTime = closingTime
        }
    }
    var body: some View {
        VStack {
            DatePicker(selection: $selectedTime,
                       in: futureTime...closingTime,
                       displayedComponents: .hourAndMinute){}
            .datePickerStyle(WheelDatePickerStyle())
            .frame(width: maxWidth, height: 120)
            .clipped()
            .padding(.bottom)
            HStack{
                Spacer()
                Button {
//                    vm.timeSelected = selectedTime
                    vm.setLatestAvailability(selectedTime)
                    withAnimation(.spring()){
                        vm.isShowingSlider.toggle()
                        vm.isTimeSet.toggle()
                    }
                } label: {
                    Text("SET")
                        .fontWeight(.bold)
                        .frame(width:  maxWidth*0.35, height: 50)
                        .background(Color(.systemBlue).opacity(0.15))
                        .cornerRadius(10)
                        .foregroundColor(Color(.systemBlue))
                }
                Spacer()
                Button {
//                    vm.timeSelected = closingTime
                    vm.setLatestAvailability(closingTime)
                    withAnimation(.spring()){
                        
                        vm.isShowingSlider.toggle()
                        vm.isTimeSet.toggle()
                    }
                } label: {
                    Text("I have all day")
                        .fontWeight(.bold)
                        .frame(width:  maxWidth*0.6, height: 50)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .frame(width: maxWidth, height: 45)
            .padding(.bottom)
            
        }
        
    }
}

struct CustomSlidere_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        CustomSlidere(vm: MatchingViewModel())
    }
}
