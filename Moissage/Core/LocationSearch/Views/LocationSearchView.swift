//
//  LocationSearchView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct LocationSearchView: View {
    @State var serviceAddress : String = ""
    @ObservedObject var viewModel : LocationSearchViewModel
    var body: some View {
        VStack{
            HStack{
                TextField("select address", text: $viewModel.queryFragment)
                    .frame(height: 44)
                    .background(Color(.systemGray4))
            }
            .padding(.bottom)
            ScrollView{
                VStack(alignment: .leading) {
                    ForEach (viewModel.results, id: \.self){
                        result in
                        LocationSearchResultCell(title: result.title,
                                                 subtitle: result.subtitle)
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(viewModel: LocationSearchViewModel())
    }
}
