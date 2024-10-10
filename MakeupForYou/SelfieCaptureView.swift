import SwiftUI

struct SelfieCaptureView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var isCameraPresented = false
    @State private var isPhotoTaken = false

    var body: some View {
        VStack {
            Text("Take a Selfie!")
                .font(.title)
                .padding()

            CameraView()
                .frame(height: 400)
                .cornerRadius(12)
                .padding()

            Spacer()

            NavigationLink(
                destination: MakeupCollectionView(),
                isActive: $isPhotoTaken,
                label: {
                    Button(action: {
                        // Action to capture the photo goes here
                        print("Capture button pressed")
                        isPhotoTaken = true // Navigate to the next page after the photo is taken
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
            )
        }
        .padding()
    }
}

struct SelfieCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        SelfieCaptureView()
    }
}
