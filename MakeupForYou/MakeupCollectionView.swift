import SwiftUI

struct MakeupCollectionView: View {
    let lightPink: Color = Color(red: 250/255, green: 182/255, blue: 206/255)
    
    // Products for skin tone
    let toneProductMap: [String: [String]] = [
        "light": ["Product A", "Product B", "Product C"],
        "medium": ["Product D", "Product E", "Product F"],
        "dark": ["Product G", "Product H", "Product I"]
    ]

    // Products for skin texture
    let textureProductMap: [String: [String]] = [
        "dry": ["Product J", "Product K", "Product L"],
        "combination": ["Product M", "Product N", "Product O"],
        "oily": ["Product P", "Product Q", "Product R"]
    ]
    
    // Properties for predicted tone and texture
    var predictedToneLabel: String
    var predictedTextureLabel: String
    
    func getProductRecommendations(predictedTone: String, predictedTexture: String) -> [String] {
        // Get recommendations for skin tone
        let toneRecommendations = toneProductMap[predictedTone.lowercased()] ?? []
        
        // Get recommendations for skin texture
        let textureRecommendations = textureProductMap[predictedTexture.lowercased()] ?? []
        
        // Combine both recommendations into one array
        let combinedRecommendations = toneRecommendations + textureRecommendations
        
        return combinedRecommendations
    }
    
    // Define a grid layout with two columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            lightPink.ignoresSafeArea()
            
            // Fetch the product recommendations based on predicted tone and texture
            let recommendedProducts = getProductRecommendations(predictedTone: predictedToneLabel, predictedTexture: predictedTextureLabel)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    // Display the recommended products
                    ForEach(recommendedProducts, id: \.self) { product in
                        VStack {
                            // Example placeholder for product image (replace with actual image handling)
                            Image(product)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(8)
                            
                            Text(product)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct MakeupCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MakeupCollectionView(predictedToneLabel: "light", predictedTextureLabel: "combination")
    }
}
