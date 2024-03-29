//
//  MassageTypeSelectionCard.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct MassageTypeSelectionCard: View {
    @Binding var selectedService: MassageType
    @Binding var viewState: ViewState
    @Binding var withDelay: Bool
    @Binding var delayedTime: Int
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: 400)
                .opacity(0.95)
            VStack{
                Text("SELECT YOUR DESIRED MASSAGE")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundColor(Color(.systemGray))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 12) {
                    ForEach (MassageType.allCases){ type in
                        Button {
                            selectedService = type
                            withAnimation(.spring()) {
                                viewState = .orderDetails
                                withDelay = true
                                delayedTime = 0
                            }
                        } label: {
                            HStack{
                                VStack(alignment: .leading, spacing: 6){
                                    Text(type.title)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Text(type.description)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }.padding(.leading, 25)
                                
                                Spacer()
                                Image(type.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.trailing, 25)
                                    .padding(.vertical,5)
                            }
                            .frame(width:UIScreen.main.bounds.size.width - 32,
                                   height: 80)
                            .background(Color(
                                .tertiarySystemBackground))
                            .opacity(0.85)
                            .cornerRadius(20)
                            .shadow(color: .secondary, radius: 3, x:0)
                            .padding(.vertical, 4)
                        }
                        
                        
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 24)
    //        .background(.white)
        .cornerRadius(20)
        }
    }
}


struct MassageTypeSelectionCard_Previews: PreviewProvider {
    static var previews: some View {
        MassageTypeSelectionCard(selectedService: .constant(.relaxing),
                                 viewState: .constant(.noInput),
                                 withDelay: .constant(true), delayedTime: .constant(0))
    }
}
