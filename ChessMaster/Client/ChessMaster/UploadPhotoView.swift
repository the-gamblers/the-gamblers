//
//  UploadPhotoView.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 3/19/24.
//
import SwiftUI
import UIKit
import AVFoundation

struct UploadPhotoView: View {
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    @State private var cameraIsReady = false
//    @State private var isActive = false
    @State private var navigateToCameraReady = false
    @State private var tempImageStorage: UIImage?

    var body: some View {
        VStack {
            Text("Upload Board Photo")
                .font(.title)
                .padding()
            Spacer()
            Button("Select file") {
                showImagePicker = true
            }
            .padding()

            Text("or")
                .font(.subheadline)
                .padding()

            Button("Open Camera & Take Photo") {
//                showCamera = true
                checkCameraAuthorization()
            }
            .padding()
            
            Spacer()
            
            Button("Continue") {
                tempImageStorage = inputImage
                navigateToCameraReady = true
            }
            .font(.headline)
            .foregroundColor(Color.white)
            .padding(.vertical, 10)
            .frame(width: 250)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: 0x0766AD)))
            .shadow(radius: 5)
            .padding()
            .disabled(inputImage == nil) // disable if no image is selected
            
            NavigationLink(destination: StartGameView(), isActive: $navigateToCameraReady) {
                EmptyView()
            }
            .hidden()
            Spacer()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .fullScreenCover(isPresented: $showCamera, onDismiss: loadImage) {
            CameraView(image: self.$inputImage, cameraIsReady: self.$cameraIsReady)
        }
//        .navigationBarItems(trailing: EditButton())
        .ignoresSafeArea(edges: .bottom)
    }

    func loadImage() {
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.showCamera = true
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.showCamera = true
                    }
                }
            }

        case .denied, .restricted:
            break
            // show an alert to the user guiding them to enable camera access in Settings
            
        @unknown default:
            break
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct UploadPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoView()
    }
}






