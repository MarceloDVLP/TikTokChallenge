import Foundation

protocol FeedInteractorProtocol {
    func fetch() -> [FeedItem]
}

final class FeedInteractor: FeedInteractorProtocol {
    
    var items: [FeedItem] = []
    var page: Int = 0
        
    func fetch()-> [FeedItem] {
        if let url = Bundle.main.url(forResource: "Feed", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(FeedModel.self, from: data)
                self.items = jsonData.looks
                page += 1
                return items
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
}
