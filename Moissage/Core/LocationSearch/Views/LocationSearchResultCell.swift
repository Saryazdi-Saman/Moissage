//
//  LocationSearchResultCell.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title : String?
    let subtitle : String
    var body: some View {
        HStack{
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(Color(.systemRed))
            
            VStack(alignment: .leading, spacing: 4){
                if let title = title {
                    Text(title.capitalized)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text(subtitle.capitalized)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                } else{
                    Text(subtitle.capitalized)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                
                Divider()
            }
            .padding(.leading, 8)
        }.padding(.vertical, 4)
        
    }
}

struct LocationSearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResultCell(title: "Home",
                                 subtitle: "635 rue saint maurice")
    }
}
