import SwiftUI
import AVKit
import AVFoundation
import SwiftData
import RealmSwift

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var router = Router.shared

    var videoOutputUrl: URL!
    

    var recordings: [Recording] = []

    init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        videoOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("videoFile")).appendingPathExtension("mp4")
        
//        try! FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)

        do {
            let realm = try Realm()

            recordings = Array(realm.objects(Recording.self))
        } catch {
            recordings = [Recording(athleteName: "Nicky", workoutTitle: "The Rise 23.1")]
        }
//        recordings = [Recording(athleteName: "Nicky", workoutTitle: "The Rise 23.1")]
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
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
                ForEach(recordings, id: \.id) { recording in
                    Spacer().frame(height: 14)
                    VStack(alignment: .leading) {
                        Text(recording.workoutTitle)
                        Text(recording.athleteName)
                        Spacer()
                        HStack {
                            Text(recording.dateRecorded, format: .dateTime.day().month().year().hour().minute())
                            Spacer()
                        }
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity)
                        .frame(height: 140.0, alignment: .topLeading)
                        .background(Color(.systemGray3))
                        .cornerRadius(14)
                    
                }
                //                VideoPlayer(player: AVPlayer(url:  videoOutputUrl))
                //                    .frame(maxHeight: .infinity)
                Spacer()
            }
            .padding(.all)
            .navigationBarTitle(Text("WOD Recorder"))
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
