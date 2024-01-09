import SwiftUI
import AVKit

struct RecorderView: View {
        
    let videoView = VideoView()
    
    var body: some View {
        ZStack {
            videoView
            VStack {
                HStack {
                    Button {
                        Router.shared.path.removeLast()
                    } label: {
                        Label("Back", systemImage: "chevron.backward")
                    }
                    .padding(.leading)
                    Spacer()
                }
                Text("14:48")
                    .font(.system(size: 72))
                    .foregroundColor(Color.white)
                    .frame(width: 200.0, height: 100.0)
                    .background(Color(.systemGroupedBackground).opacity(0.5))
                    .cornerRadius(15)
                    .padding(.top, 30)
                
                Spacer()
                HStack {
                    Button {
                        videoView.startVideoButtonTapped()
                    } label: {
                        Label("Start Video", systemImage: "video")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Button {
                    } label: {
                        Label("Start Timer", systemImage: "stopwatch")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(Color(.systemRed))
                    .disabled(true)
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
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
