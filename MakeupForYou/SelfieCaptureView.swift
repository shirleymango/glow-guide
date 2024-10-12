import SwiftUI

struct SelfieCaptureView: View {
    let lightPink: Color = Color(red: 250 / 255, green: 182 / 255, blue: 206 / 255)
    let hotPink: Color = Color(red: 242 / 255, green: 12 / 255, blue: 93 / 255)

    @State private var capturedImage: UIImage? = nil
    @State private var showLoadingView = false
    @State private var isPhotoTaken = false
    @State private var imagePath: String? = nil // To store the image path

    var body: some View {
        ZStack {
            lightPink
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Take a Selfie!")
                    .font(.title)
                    .padding()
                    .foregroundColor(.black)

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
                                .background(hotPink) // Soft pastel pink background
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        NavigationLink(
                            destination: LoadingView(),
                            isActive: $showLoadingView,
                            label: {
                                Button(action: {
                                    // Show the loading view and save the image before transitioning
                                    if let image = capturedImage {
                                        saveImageToDocumentDirectory(image: image)
                                    }
                                    showLoadingView = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        isPhotoTaken = true
                                    }
                                }) {
                                    Text("Use Photo")
                                        .padding()
                                        .background(Color.green) // Soft custom mint green background
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
                                    .stroke(hotPink) // Pink border for a cute touch
                            )
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .foregroundColor(hotPink) // Pink camera icon
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

    // Save image to the documents directory
    private func saveImageToDocumentDirectory(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("selfie.jpg")
            try? data.write(to: filename)
            imagePath = filename.path // Save the file path for later use
            print("Image saved to: \(imagePath ?? "No Path")") // Display the saved image path
            isPhotoTaken = true // Navigate to the next screen
        }
    }

    // Get the document directory path
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct SelfieCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        SelfieCaptureView()
    }
}
