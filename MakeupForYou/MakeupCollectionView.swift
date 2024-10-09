//
//  MakeupCollectionView.swift
//  MakeupForYou
//
//  Created by ZhuMacPro on 10/9/24.
//

import SwiftUI

struct MakeupCollectionView: View {
    // Sample data for the collection view
    let makeupItems = Array(1...20).map { "Item \($0)" }

    // Define a grid layout with two columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(makeupItems, id: \.self) { item in
                    VStack {
                        Rectangle()
                            .fill(Color.pink)
                            .frame(height: 100)
                            .cornerRadius(8)
                        
                        Text(item)
                            .font(.headline)
                            .padding(.top, 5)
                    }
                }
            }
            .padding()
            .navigationTitle("Makeup Collection")
        }
    }
}

struct MakeupCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MakeupCollectionView()
    }
}
