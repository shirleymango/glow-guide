import SwiftUI

struct SelfieCaptureView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var showLoadingView = false
    @State private var isPhotoTaken = false

    // Custom pastel colors
    let customMint = Color(red: 189 / 255, green: 252 / 255, blue: 201 / 255)
    let customPastelPink = Color(red: 255 / 255, green: 182 / 255, blue: 193 / 255)

    var body: some View {
        VStack {
            Text("Take a Selfie!")
                .font(.title)
                .padding()

            if let image = capturedImage {
                // Display the captured image in place of the camera feed
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 400)
                    .cornerRadius(12)
                    .padding()

                HStack(spacing: 20) {
                    Button(action: {
                        // Retake the photo by resetting the captured image
                        capturedImage = nil // Show the camera feed again
                    }) {
                        Text("Retake Photo")
                            .padding()
                            .background(customPastelPink.opacity(0.8)) // Soft pastel pink background
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    NavigationLink(
                        destination: LoadingView(),
                        isActive: $showLoadingView,
                        label: {
                            Button(action: {
                                // Show the loading view and then transition to the makeup collection view
                                showLoadingView = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isPhotoTaken = true
                                }
                            }) {
                                Text("Use Photo")
                                    .padding()
                                    .background(customMint.opacity(0.8)) // Soft custom mint green background
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    )
                }
                .padding(.top, 20)
            } else {
                // Show the live camera feed when no photo is taken
                CameraView(capturedImage: $capturedImage)
                    .frame(height: 400)
                    .cornerRadius(12)
                    .padding()

                Spacer()

                Button(action: {
                    // Capture photo functionality triggered when button is tapped
                    NotificationCenter.default.post(name: NSNotification.Name("capturePhoto"), object: nil)
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(customPastelPink, lineWidth: 4) // Pink border for a cute touch
                        )
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(customPastelPink) // Pink camera icon
                                .font(.system(size: 24))
                        )
                        .shadow(radius: 5)
                }
                .padding(.bottom, 40)
            }
        }
        .padding()
        .background(
            NavigationLink(
                destination: MakeupCollectionView(),
                isActive: $isPhotoTaken,
                label: { EmptyView() }
            )
        )
    }
}

struct SelfieCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        SelfieCaptureView()
    }
}
