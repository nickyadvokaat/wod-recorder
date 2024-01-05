//
//  RecorderView.swift
//  wod-recorder
//
//  Created by Nicky Advokaat on 03/01/2024.
//

import SwiftUI
import AVKit

struct RecorderView: View {
    
    let previewView: PreviewView
    
    init() {
        self.previewView = PreviewView()
        
//        let captureSession = AVCaptureSession()
//        captureSession.beginConfiguration()
//        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                  for: .video, position: .unspecified)
//        guard
//            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
//            captureSession.canAddInput(videoDeviceInput)
//            else { return }
//        captureSession.addInput(videoDeviceInput)
//        
//        let videoOutput = AVCaptureVideoDataOutput()
//        guard captureSession.canAddOutput(videoOutput) else { return }
//        captureSession.sessionPreset = .high
//        captureSession.addOutput(videoOutput)
//        captureSession.commitConfiguration()
//        
//        self.previewView.videoPreviewLayer.session = captureSession
//        
//        captureSession.startRunning()
    }

    var body: some View {
        VStack {
            VideoView()
        }
    }
    
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }


    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
        // Set up the capture session.
    }
}


#Preview {
    RecorderView()
}

class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

