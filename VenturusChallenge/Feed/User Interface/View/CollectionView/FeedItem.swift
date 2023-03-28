import Foundation

class FeedItem: Codable, Hashable {
    
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
    var page: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case songUrl = "song_url"
        case body
        case profileURL = "profile_picture_url"
        case username
        case compressedURL = "compressed_for_ios_url"
        case page
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
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
    var looks: [FeedItem]
}
