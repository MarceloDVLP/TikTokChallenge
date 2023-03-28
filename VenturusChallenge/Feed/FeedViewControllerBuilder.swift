import UIKit

final class FeedViewControllerBuilder {
    
    static func make() -> UIViewController {
        let interactor = FeedInteractor()
        
        let presenter = FeedPresenter(interactor: interactor)
        
        let viewController = FeedViewController(presenter: presenter)
        presenter.viewController = viewController
                
        return viewController
    }
}
