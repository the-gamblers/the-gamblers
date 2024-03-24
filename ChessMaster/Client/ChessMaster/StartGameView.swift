//
//  StartGameView.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 3/19/24.
//

import SwiftUI
import AVFoundation

struct StartGameView: View {
    @State private var isCameraActive = false
    @State private var cameraSession = AVCaptureSession()
    @State private var navigateToEndGame = false

    var body: some View {
        ZStack {
            Color(red: 238/255, green: 238/255, blue: 238/255)
                .ignoresSafeArea()

            VStack {
                Spacer()
                CameraPreviewView(session: cameraSession)
                    .cornerRadius(25)
                    .aspectRatio(4/3, contentMode: .fit)
                    .shadow(radius: 5)
                    .onAppear {
                        isCameraActive = true
                        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                            startCameraSession()
                        } else {
                            AVCaptureDevice.requestAccess(for: .video) { granted in
                                if granted {
                                    startCameraSession()
                                }
                            }
                        }
                    }
                
                Spacer()
                
                if isCameraActive {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Camera is Ready")
                            .foregroundColor(.green)
                    }
                    .transition(.scale)
                    .animation(.easeIn, value: isCameraActive)
                }
                
                Spacer()
                
                NavigationLink(destination: FinishGameView(), isActive: $navigateToEndGame) {
                        EmptyView()
                }

                Button("START GAME") {
                    navigateToEndGame = true
                }
                .font(.headline)
                .foregroundColor(Color.white)
                .padding(.vertical, 15)
                .frame(width: 250)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: 0x0766AD)))
                .shadow(radius: 5)
                
                Spacer()
            }
        }
    }

    func startCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            // setup and start the camera session
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            guard let input = try? AVCaptureDeviceInput(device: device) else { return }

            if cameraSession.canAddInput(input) {
                cameraSession.addInput(input)
            }

            cameraSession.startRunning()
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.frame = uiView.bounds
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}

