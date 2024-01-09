import AVFoundation
import UIKit
import SwiftUI

struct VideoView: UIViewControllerRepresentable {
    typealias UIViewControllerType = VideoViewController
    
    let vc: VideoViewController? = VideoViewController()
    
    func makeUIViewController(context: Context) -> VideoViewController {
        if let vc = vc {
            return vc
        }
        return VideoViewController()
    }
    
    func updateUIViewController(_ uiViewController: VideoViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    
    func startVideoButtonTapped() {
        vc?.startVideoRecording()
    }
}

final class VideoViewController: UIViewController {
    var previewLayer: AVCaptureVideoPreviewLayer!
//    var videoManager: VideoManager!
    
    
    var captureSession = AVCaptureSession()
    
    var videoSession: AVCaptureSession!
    var videoDataOutput = AVCaptureVideoDataOutput()
    var dataOutputQueue = DispatchQueue(label: "nl.nickyadvokaat.wod-recorder")
    var assetWriter: AVAssetWriter!
    var assetWriterInput: AVAssetWriterInput!
    
    var isWriting = false
    var sessionAtSourceTime: CMTime?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")

        setup()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    func startVideoRecording() {
        stop()
    }
}

extension VideoViewController {
    func setup() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        captureSession.beginConfiguration()
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
      
        setUpAssetWriter()
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    func setUpAssetWriter() {
        do {
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
            guard captureSession.canAddOutput(videoDataOutput) else { fatalError() }
            captureSession.addOutput(videoDataOutput)
           
            let outputFileLocation = videoFileLocation()
            assetWriter = try AVAssetWriter(outputURL: outputFileLocation, fileType: AVFileType.mp4)
            assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoDataOutput.recommendedVideoSettingsForAssetWriter(writingTo: .mp4))
            assetWriterInput.expectsMediaDataInRealTime = true
            
            if assetWriter.canAdd(assetWriterInput) {
                assetWriter.add(assetWriterInput)
                print("video input added")
            } else {
                print("no input added")
            }
            
            isWriting = true
            assetWriter.startWriting()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func failed() {
        print("failed")
    }
    
    func videoFileLocation() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let videoOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("videoFile")).appendingPathExtension("mp4")
        do {
            if FileManager.default.fileExists(atPath: videoOutputUrl.path) {
                try FileManager.default.removeItem(at: videoOutputUrl)
                print("file removed")
            }
        } catch {
            print(error)
        }
        
        return videoOutputUrl
    }
    
    func stop() {
        isWriting = false
        assetWriterInput.markAsFinished()
        assetWriter.finishWriting {
            self.testPrint()
        }
        print("marked as finished")
        
    }
    
    func testPrint() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let videoOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("videoFile")).appendingPathExtension("mp4")
        print(videoOutputUrl)
        let asset = AVAsset(url: videoOutputUrl)
        print("Meta:")
        print(asset.metadata)
        print(asset.duration)
        print(".")
    }
}

extension VideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !isWriting {return}
        
        if sessionAtSourceTime == nil {
            sessionAtSourceTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            assetWriter.startSession(atSourceTime: sessionAtSourceTime!)
            print("Writing")
        }
        
        if(output === videoDataOutput && assetWriterInput.isReadyForMoreMediaData) {
            assetWriterInput.append(sampleBuffer)
        }
    }
}
