import UIKit

final class FeedView: UIView {
        
    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, FeedItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FeedItem>

    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: frame, collectionViewLayout: makeLayoutVideo())
    }()
    
    var items: [FeedItem] = []
    var didScrollToTheEnd: (() -> ())?
    
    private lazy var dataSource: DataSource = makeDataSource()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.pinView(in: self)
        collectionView.isPagingEnabled = true
    }
    
    func cellRegistration() -> UICollectionView.CellRegistration<FeedCell, FeedItem> {
        return UICollectionView.CellRegistration<FeedCell, FeedItem> { (cell, indexPath, item) in
            cell.load(with: item)
        }
    }
    
    func makeDataSource() -> DataSource {
        let cellRegistration = cellRegistration()
        
        let dataSource =  UICollectionViewDiffableDataSource<Section, FeedItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: FeedItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,                                                                 for: indexPath, item: item)
        }
        
        return dataSource
    }
    
    func show(_ items: [FeedItem]) {
        self.items = items
        applySnapshot(animatingDifferences: true)
    }
    
    func makeLayoutVideo() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: {
            guard self.items.count > 0 else { return }
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: true)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
