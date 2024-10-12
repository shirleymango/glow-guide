import SwiftUI
import UIKit
import CoreML
import Accelerate

struct SelfieCaptureView: View {
    let lightPink: Color = Color(red: 250 / 255, green: 182 / 255, blue: 206 / 255)
    let hotPink: Color = Color(red: 242 / 255, green: 12 / 255, blue: 93 / 255)

    @State private var capturedImage: UIImage? = nil
    @State private var showLoadingView = false
    @State private var isPhotoTaken = false
    @State private var imagePath: String? = nil // To store the image path
    @State private var predictionResult: (tone: String?, texture: String?)? = nil // Store prediction result

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
                                        // Call prediction function here
                                        predictionResult = predictSkinToneAndTexture(for: image)
                                        if let result = predictionResult {
                                            print("Predicted Skin Tone: \(result.tone ?? "Unknown")")
                                            print("Predicted Skin Texture: \(result.texture ?? "Unknown")")
                                        }
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

                    if let result = predictionResult {
                        Text("Predicted Skin Tone: \(result.tone ?? "Unknown")")
                        Text("Predicted Skin Texture: \(result.texture ?? "Unknown")")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(.top, 20)
                    }
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
                    destination: MakeupCollectionView(
                        predictedToneLabel: predictionResult?.tone ?? "Unknown",
                        predictedTextureLabel: predictionResult?.texture ?? "Unknown"
                    ),
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

func predictSkinToneAndTexture(for image: UIImage) -> (tone: String?, texture: String?)? {
    // Ensure the model is loaded correctly
    guard let model = try? skin_model(configuration: .init()) else {
        print("Failed to load model")
        return nil
    }

    // Preprocess the image to MLMultiArray
    guard let mlArray = imageToMultiArray(image: image, size: CGSize(width: 128, height: 128)) else {
        print("Failed to convert image to MLMultiArray")
        return nil
    }

    // Make the prediction
    guard let prediction = try? model.prediction(input_1: mlArray) else {
        print("Failed to make prediction")
        return nil
    }

    // Extract results
    // Assuming the resultArray for tone and texture are available as [Double] arrays
    let toneArray: [Double] = [prediction.Identity_1[0].doubleValue]  // Replace with actual tone array output
    let textureArray: [Double] = [prediction.Identity_1[1].doubleValue]  // Replace with actual texture array output

    // Define the labels for tone and texture
    let toneLabels = ["dark", "light", "medium"]
    let textureLabels = ["combination", "dry", "oily"]

    // Function to get the label from the prediction array
    func getLabel(from array: [Double], labels: [String]) -> String? {
        guard let maxIndex = array.firstIndex(of: array.max() ?? 0) else {
            return nil
        }
        return labels[maxIndex]
    }

    // Get the predicted tone and texture labels
    if let predictedToneLabel = getLabel(from: toneArray, labels: toneLabels),
       let predictedTextureLabel = getLabel(from: textureArray, labels: textureLabels) {
        print("*************")
        print("Predicted Skin Tone: \(predictedToneLabel)")
        print("Predicted Skin Texture: \(predictedTextureLabel)")
        return (tone: predictedToneLabel, texture: predictedTextureLabel)
    }
    
    return (tone: "Sample Tone", texture: "Sample Texture")
}

// Helper function to create MLMultiArray from UIImage and add batch dimension
func imageToMultiArray(image: UIImage, size: CGSize) -> MLMultiArray? {
    // Convert UIImage to CGImage
    guard let cgImage = image.cgImage else {
        return nil
    }

    // Create MLMultiArray to hold image data with 4D shape: [1, 3, height, width]
    guard let mlArray = try? MLMultiArray(shape: [1, NSNumber(value: Int(size.height)), NSNumber(value: Int(size.width)), 3], dataType: .float32) else {
        return nil
    }

    // Create a context for image processing
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)
    guard let context = CGContext(data: mlArray.dataPointer,
                                  width: Int(size.width),
                                  height: Int(size.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: Int(size.width) * 4,
                                  space: rgbColorSpace,
                                  bitmapInfo: bitmapInfo.rawValue) else {
        return nil
    }
    
    // Draw the image in the context
    context.draw(cgImage, in: CGRect(origin: .zero, size: size))
    
    // Normalize the image pixel values between 0 and 1
    let count = Int(size.height * size.width)
    for i in 0..<count {
        mlArray[[0, 0, NSNumber(value: i % Int(size.height)), NSNumber(value: i / Int(size.height))]] = NSNumber(value: Float(mlArray[[0, 0, NSNumber(value: i % Int(size.height)), NSNumber(value: i / Int(size.height))]].floatValue) / 255.0)
        mlArray[[0, 1, NSNumber(value: i % Int(size.height)), NSNumber(value: i / Int(size.height))]] = NSNumber(value: Float(mlArray[[0, 1, NSNumber(value: i % Int(size.height)), NSNumber(value: i / Int(size.height))]].floatValue) / 255.0)
        mlArray[[0, 2, NSNumber(value: i % Int(size.height)), NSNumber(value: i / Int(size.height))]] = NSNumber(value: Float(mlArray[[0, 2, NSNumber(value: i % Int(size.height)), NSNumber(value: i / Int(size.height))]].floatValue) / 255.0)
    }
    
    return mlArray
}
