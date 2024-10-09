//
//  ContentView.swift
//  MakeupForYou
//
//  Created by ZhuMacPro on 10/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Glow Guide!")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: SelfieCaptureView()) {
                    Text("Start Here")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("This is the detail page!")
                .font(.title)
                .padding()
        }
        .navigationTitle("Detail View")
    }
}
