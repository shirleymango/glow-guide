//
//  MakeupCollectionView.swift
//  MakeupForYou
//
//  Created by ZhuMacPro on 10/9/24.
//

import SwiftUI

struct MakeupCollectionView: View {
    let lightPink : Color = Color(red: 250/255, green: 182/255, blue: 206/255)
    
    // Sample data for the collection view
    let makeupItems = [
        ["1", "Mattifying Waterproof Setting Spray"],
        ["2", "NARS Radiant Concealer"],
        ["3", "Airbrush Flawless Waterproof Setting Spray"],
        ["4", "Lip Glowy Balm"],
        ["5", "Benetint Cheek Blush Stain"]
    ]

    // Define a grid layout with two columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            lightPink.ignoresSafeArea()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(makeupItems, id: \.self) { item in
                        VStack {
                            Image(item[0])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(8)
                            Text(item[1])
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct MakeupCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MakeupCollectionView()
    }
}
