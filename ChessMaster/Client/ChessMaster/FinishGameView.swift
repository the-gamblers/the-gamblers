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
    @State private var navigateToGameSaving = false

    var body: some View {
        ZStack {
            Color(red: 238/255, green: 238/255, blue: 238/255)
                .ignoresSafeArea()

            VStack {
                Spacer()
                CameraPreviewView(session: cameraSession)
                    .cornerRadius(25)
                    .aspectRatio(9/16, contentMode: .fit)
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
                
                Button("END GAME") {
                    navigateToGameSaving = true
                }
                .font(.headline)
                .foregroundColor(Color.white)
                .padding(.vertical, 15)
                .frame(width: 250)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: 0x0766AD)))
                .shadow(radius: 5)
                .padding(.bottom, 50)
                
                Spacer()
                
                NavigationLink(destination: GameSavingView(), isActive: $navigateToGameSaving) {
                    EmptyView()
                }
                .hidden()
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

struct FinishGameView_Previews: PreviewProvider {
    static var previews: some View {
        FinishGameView()
    }
}





