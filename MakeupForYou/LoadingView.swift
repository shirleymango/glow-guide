import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Text("Loading...")
                .font(.title)
                .foregroundColor(Color.black)
                .padding(.bottom, 20)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
