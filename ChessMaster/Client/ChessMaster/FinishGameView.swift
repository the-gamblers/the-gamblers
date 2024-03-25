//
//  FinishGameView.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 3/22/24.
//

import SwiftUI
import AVFoundation


struct FinishGameView: View {
    @State private var cameraSession = AVCaptureSession()

    var body: some View {
        ZStack {
            Color(red: 238/255, green: 238/255, blue: 238/255)
                .ignoresSafeArea()

            VStack {
                Spacer()
                CameraPreviewView(session: cameraSession)
                    .cornerRadius(25)
                    .aspectRatio(9/16, contentMode: .fit) // Switch back to .fit if .fill is zooming in too much
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .shadow(radius: 5)
                    .onAppear {
                        startCameraSession()
                    }
                    .onDisappear {
                        cameraSession.stopRunning()
                    }

                Spacer(minLength: 30)
                
                // Adjust the spacing as needed
                Button("END GAME") {
                    // Handle the action when "END GAME" is tapped
                }
                .font(.headline)
                .foregroundColor(Color.white)
                .padding(.vertical, 15)
                .frame(width: 250)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: 0x0766AD)))
                .shadow(radius: 5)
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
    }

    func startCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Setup and start the camera session here
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            guard let input = try? AVCaptureDeviceInput(device: device) else { return }

            if cameraSession.canAddInput(input) {
                cameraSession.addInput(input)
            }

            cameraSession.startRunning()
        }
    }
}

struct FinishGameView_Previews: PreviewProvider {
    static var previews: some View {
        FinishGameView()
    }
}





