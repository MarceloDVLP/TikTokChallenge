import UIKit

class VideoItem: Codable, Hashable {
    
    var id: Int
    var songUrl: URL
    var body: String
    var profileURL: URL
    var username: String
    var compressedURL: URL
    var identifier = UUID()
    var isFavorite: Bool = false
    var likes: Int = Int.random(in: 0...999)
    var favoriteCount: Int = Int.random(in: 0...999)
    
    enum CodingKeys: String, CodingKey {
        case id
        case songUrl = "song_url"
        case body
        case profileURL = "profile_picture_url"
        case username
        case compressedURL = "compressed_for_ios_url"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: VideoItem, rhs: VideoItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func favorite() {
        if isFavorite == false {
            favoriteCount += 1
        } else {
            favoriteCount -= 1
        }
        self.isFavorite = !isFavorite
    }
    
    func like() {
        self.likes += 1
    }
}

class FeedModel: Codable {
    var looks: [VideoItem]
}

final class PhotoLoading: VideoItem {}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
