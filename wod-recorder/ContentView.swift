import SwiftUI
import AVKit
import AVFoundation
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var router = Router.shared

    var videoOutputUrl: URL!

    init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        videoOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("videoFile")).appendingPathExtension("mp4")
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                Button {
                    Router.shared.path.append("Setup")
                } label: {
                    Label("New Recording", systemImage: "video")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .navigationDestination(for: String.self) { route in
                    if(route == "Setup"){
                        SetupView()
                            .navigationTitle("New Recording") .navigationBarTitleDisplayMode(.large)
                    } else {
                        RecorderView().navigationBarHidden(true)
                    }
                }
                VideoPlayer(player: AVPlayer(url:  videoOutputUrl))
                    .frame(maxHeight: .infinity)
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .navigationBarTitle(Text("WOD Recorder"))
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
