import UIKit

final class FeedViewController: UIViewController {
    
    private var presenter: FeedPresenterProtocol
    
    private lazy var photoView: FeedView = { return FeedView() }()

    init(presenter: FeedPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPhotoView()
        presenter.viewDidLoad()
    }
    
    func addPhotoView() {
        view.backgroundColor = .black
        photoView.pinView(in: view)
        photoView.didScrollToTheEnd = { [weak self] in
            self?.presenter.didScrollToTheEnd()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeedViewController: FeedPresenterDelegate {

    func show(_ items: [FeedItem]) {
        photoView.show(items)
    }
}
