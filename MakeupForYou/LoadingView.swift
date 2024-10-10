import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Text("Loading...")
                .font(.title)
                .foregroundColor(Color.black)
                .padding(.bottom, 20)

            ZStack {
                Circle()
                    .trim(from: 0, to: 0.8)
                    .stroke(Color.pink, lineWidth: 6)
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                            self.isAnimating = true
                        }
                    }
            }
            .frame(width: 50, height: 50) // Fixed frame to prevent layout changes
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
