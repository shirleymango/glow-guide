//
//  ContentView.swift
//  MakeupForYou
//
//  Created by ZhuMacPro on 10/9/24.
//

import SwiftUI

struct ContentView: View {
    let lightPink : Color = Color(red: 250/255, green: 182/255, blue: 206/255)
    let hotPink : Color = Color(red: 242/255, green: 12/255, blue: 93/255)

    var body: some View {
        NavigationView {
            ZStack {
                lightPink.ignoresSafeArea()
                VStack {
                    Text("Welcome to")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text("GLOW GUIDE")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    NavigationLink(destination: SelfieCaptureView()) {
                        Text("Start Here")
                            .padding()
                            .background(hotPink)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
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
