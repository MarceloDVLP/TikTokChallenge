import Foundation

protocol PhotoGalleryInteractorProtocol {
    func fetchImages()
}

protocol PhotoGalleryInteractorDelegate {
    func show(_ items: [VideoItem])
    func showTryAgain()
}

final class PhotoGalleryInteractor: PhotoGalleryInteractorProtocol {
    
    private var service: RemoteService
    
    var presenter: PhotoGalleryInteractorDelegate?
    
    var items: [VideoItem] = []
    var page: Int = -1
    
    init(service: RemoteService) {
        self.service = service
    }
    
    func fetchImages() {
        page += 1
        items = service.fetch()
        presenter?.show(items)
    }
}
