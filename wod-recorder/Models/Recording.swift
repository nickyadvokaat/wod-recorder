import Foundation
import RealmSwift

class Recording: Object {
    @Persisted var id = UUID()
    @Persisted var athleteName: String
    @Persisted var workoutTitle: String
    @Persisted var dateRecorded: Date
    @Persisted var videoURL: String

    convenience init(athleteName: String, workoutTitle: String) {
        self.init()
        self.athleteName = athleteName
        self.workoutTitle = workoutTitle
        self.dateRecorded = Date()
        self.videoURL = ""
    }
    
    func getURL()-> URL {
        return URL(string: self.videoURL)!
    }
    
    func setVideoURL(videoURL: String) {
        self.videoURL = videoURL
    }
}
