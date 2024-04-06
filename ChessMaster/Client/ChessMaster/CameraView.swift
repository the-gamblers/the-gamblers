//
//  CameraView.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 3/19/24.
//
import SwiftUI
import UIKit
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var cameraIsReady: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.cameraIsReady = true
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.cameraIsReady = false
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

//private func checkCameraAuthorization(completion: @escaping (Bool) -> Void) {
//    switch AVCaptureDevice.authorizationStatus(for: .video) {
//    case .authorized:
//        completion(true)
//    case .notDetermined:
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            DispatchQueue.main.async {
//                completion(granted)
//            }
//        }
//    case .denied, .restricted:
//        completion(false)
//    @unknown default:
//        completion(false)
//    }
//}

