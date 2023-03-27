import UIKit

final class PhotoGalleryViewControllerBuilder {
    
    static func make() -> UIViewController {
        let service = RemoteService()
        let interactor = PhotoGalleryInteractor(service: service)

        let router = PhotoGalleryRouter()
        
        let presenter = PhotoGalleryPresenter(interactor: interactor, router: router)
        interactor.presenter = presenter
        
        let viewController = PhotoGalleryViewController(presenter: presenter)
        presenter.viewController = viewController
        
        router.viewController = viewController
        
        return viewController
    }
}
