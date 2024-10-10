import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.capturedImage = $capturedImage
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}

    class CameraViewController: UIViewController {
        var captureSession: AVCaptureSession?
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        var photoOutput = AVCapturePhotoOutput()
        var capturedImage: Binding<UIImage?>?

        override func viewDidLoad() {
            super.viewDidLoad()
            setupCamera()

            // Listen for capture photo notifications
            NotificationCenter.default.addObserver(self, selector: #selector(capturePhoto), name: NSNotification.Name("capturePhoto"), object: nil)
        }

        private func setupCamera() {
            captureSession = AVCaptureSession()
            guard let captureSession = captureSession else { return }
            captureSession.sessionPreset = .photo

            guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let input = try? AVCaptureDeviceInput(device: frontCamera) else {
                print("Unable to access front camera!")
                return
            }

            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }

            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            if let videoPreviewLayer = videoPreviewLayer {
                videoPreviewLayer.videoGravity = .resizeAspectFill
                videoPreviewLayer.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer)
            }

            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
        }

        @objc func capturePhoto() {
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            videoPreviewLayer?.frame = view.bounds
        }
    }
}

extension CameraView.CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let imageData = photo.fileDataRepresentation(),
              let uiImage = UIImage(data: imageData) else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }

        DispatchQueue.main.async {
            // Set the captured image to the binding so it can be used in the SwiftUI view
            self.capturedImage?.wrappedValue = uiImage
        }
    }
}
