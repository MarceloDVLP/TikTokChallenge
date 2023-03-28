import Foundation


protocol FeedPresenterProtocol {
    func viewDidLoad()
    func didScrollToTheEnd()
}

protocol FeedPresenterDelegate: AnyObject {
    func show(_ items: [FeedItem])
}

final class FeedPresenter: FeedPresenterProtocol {
        
    private var interactor: FeedInteractorProtocol
    weak var viewController: FeedPresenterDelegate?
    
    init(interactor: FeedInteractorProtocol) {
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        let items = interactor.fetch()
        viewController?.show(items)
    }
        
    func didScrollToTheEnd() {}
}
