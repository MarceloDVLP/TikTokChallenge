import Foundation

protocol RemoteServiceProtocol {
    func fetch()-> [VideoItem]
}

final class RemoteService: RemoteServiceProtocol {
        
    func fetch()-> [VideoItem] {
        if let url = Bundle.main.url(forResource: "Feed", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(FeedModel.self, from: data)
                return jsonData.looks
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
}

enum RemoteServiceError: Error, Equatable {
    case serverError
}
