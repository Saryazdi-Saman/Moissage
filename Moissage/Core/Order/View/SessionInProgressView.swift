//
//  SessionInProgressView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-16.
//

//import SwiftUI
//
//struct SessionInProgressView: View {
//    @EnvironmentObject var vm : LocationSearchViewModel
//    var body: some View {
//        ZStack(alignment: .top) {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(.secondarySystemBackground))
//                .frame(maxHeight: 400)
//                .opacity(0.95)
//            VStack(spacing: 10){
//                HStack{
//                    
//                    Text("Kobra will be there in 20 minutes")
//                        .font(.headline)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.primary)
//                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading)
//                    Button {
//
//                    } label: {
//                        ZStack{
//                                Circle()
//                                    .fill(Color(.secondarySystemBackground))
//                                    .shadow(color:.secondary ,radius: 4)
//                                    .frame(width: 60, height: 60)
//                            Image(systemName: "message")
//                                    .font(.title3)
//                                    .foregroundColor(.primary)
//                            }
//                    }
//                    .padding()
//                }
//                
//                Divider()
//                
//                Flower()
//                    .frame(height: 200)
//                HStack{
//                    Button {
//                        
//                    } label: {
//                        Text("CANCEL")
//                            .fontWeight(.bold)
//                            .frame(width: 200, height: 50)
//                            .background(Color(.systemRed))
//                            .cornerRadius(25)
//                            .foregroundColor(.white)
//                            .shadow(color:.secondary ,radius: 4)
//                    }
////                    Button {
////
////                    } label: {
////                        ZStack{
////                                RoundedRectangle(cornerRadius: 15)
////                                    .fill(Color(.secondarySystemBackground))
////                                    .shadow(color:.secondary ,radius: 4)
////                                    .frame(width: 50, height: 50)
////                            Image(systemName: "message")
////                                    .font(.title3)
////                                    .foregroundColor(.primary)
////                            }
////                    }
//                }
//                .padding(.horizontal, 20)
//                
//            }
//        }
//    }
//}
//
//struct SessionInProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionInProgressView()
//            .environmentObject(LocationSearchViewModel())
//    }
//}
