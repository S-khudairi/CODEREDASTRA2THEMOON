import SwiftUI
import PhotosUI

struct CaptureAnalyzeView: View {
    @State private var showCamera = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @State private var analysisResult: String? = nil
    @State private var isAnalyzing = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Group {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 280)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.secondary, lineWidth: 1)
                            )
                            .accessibilityLabel("Selected photo for analysis")
                    } else {
                        ContentUnavailableView("No Photo", systemImage: "photo", description: Text("Take or upload a photo to analyze its recyclability."))
                    }
                }
                .frame(maxWidth: .infinity)

                if isAnalyzing {
                    ProgressView("Analyzing…")
                } else if let analysisResult {
                    AnalysisResultView(result: analysisResult)
                }

                HStack(spacing: 12) {
                    Button {
                        showCamera = true
                    } label: {
                        Label("Take Photo", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityHint("Opens the camera to take a photo for analysis")
                    .sheet(isPresented: $showCamera) {
                        CameraCaptureView(image: $image)
                    }

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Upload", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .onChange(of: selectedItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                image = uiImage
                                analysisResult = nil
                            }
                        }
                    }
                }

                Button {
                    analyzeImage()
                } label: {
                    Label("Analyze", systemImage: "wand.and.stars")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(image == nil || isAnalyzing)

                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Capture & Analyze")
        }
    }

    private func analyzeImage() {
        guard image != nil else { return }
        isAnalyzing = true
        analysisResult = nil
        // Placeholder: simulate analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            // In a future step, replace with on-device model inference to detect materials.
            self.analysisResult = "Material: Plastic (PET)\nRecyclable: Yes\nTips: Rinse and remove cap before recycling."
            self.isAnalyzing = false
        }
    }
}

private struct AnalysisResultView: View {
    let result: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Analysis Result", systemImage: "checkmark.seal")
                .font(.headline)
            Text(result)
                .font(.body)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

// Simple camera capture wrapper
struct CameraCaptureView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraCaptureView
        init(_ parent: CameraCaptureView) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let img = info[.originalImage] as? UIImage {
                parent.image = img
            }
            parent.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
