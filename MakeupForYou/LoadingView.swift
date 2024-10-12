import SwiftUI

struct LoadingView: View {
    let lightPink : Color = Color(red: 250/255, green: 182/255, blue: 206/255)
    
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            lightPink.ignoresSafeArea()
            VStack {
                Text("Loading...")
                    .font(.title)
                    .foregroundColor(Color.black)
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
