import SwiftUI

struct SelfieCaptureView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var isPhotoTaken = false

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

                HStack {
                    Button(action: {
                        // Retake the photo by resetting the captured image
                        capturedImage = nil // Show the camera feed again
                    }) {
                        Text("Retake Photo")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    NavigationLink(
                        destination: MakeupCollectionView(),
                        isActive: $isPhotoTaken,
                        label: {
                            Button(action: {
                                // Confirm the photo and navigate to the next page
                                isPhotoTaken = true
                            }) {
                                Text("Use Photo")
                                    .padding()
                                    .background(Color.green)
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
                                .stroke(Color.gray, lineWidth: 4)
                        )
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 24))
                        )
                        .shadow(radius: 5)
                }
                .padding(.bottom, 40)
            }
        }
        .padding()
    }
}
