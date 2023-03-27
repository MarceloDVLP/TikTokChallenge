import UIKit

final class PhotoGalleryRouter {
    
    weak var viewController: PhotoGalleryViewController?
    
    func showDetail(_ item: VideoItem) {
        let detailViewController = PhotoDetailViewController(item)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
