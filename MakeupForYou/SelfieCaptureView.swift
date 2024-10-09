//
//  SelfieCaptureView.swift
//  MakeupForYou
//
//  Created by ZhuMacPro on 10/9/24.
//

import SwiftUI

struct SelfieCaptureView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var isCameraPresented = false

    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()
            } else {
                Text("Take a selfie!")
                    .font(.title)
                    .padding()
            }

            Button(action: {
                isCameraPresented = true
            }) {
                Text("Open Camera")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $isCameraPresented) {
                CameraView(capturedImage: $capturedImage)
            }
        }
    }
}

struct SelfieCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        SelfieCaptureView()
    }
}


