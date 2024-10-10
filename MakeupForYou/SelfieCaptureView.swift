import SwiftUI

struct SelfieCaptureView: View {
    var body: some View {
        VStack {
            Text("Take a Selfie!")
                .font(.title)
                .padding()

            CameraView()
                .frame(height: 400)
                .cornerRadius(12)
                .padding()

            NavigationLink(destination: MakeupCollectionView()) {
                Text("Proceed to Makeup Collection")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
        }
        .navigationTitle("Selfie Capture")
    }
}

struct SelfieCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        SelfieCaptureView()
    }
}
