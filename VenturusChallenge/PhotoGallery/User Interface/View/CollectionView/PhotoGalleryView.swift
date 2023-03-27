import UIKit

final class PhotoGalleryView: UIView {
        
    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, VideoItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, VideoItem>

    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: frame, collectionViewLayout: makeLayoutVideo())
    }()
    
    var items: [VideoItem] = []
    
    var didSelect: ((VideoItem) -> ())?
    var didScrollToTheEnd: (() -> ())?
    
    private lazy var dataSource: DataSource = makeDataSource()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.pinView(in: self)
        collectionView.isPagingEnabled = true
    }
    
    func cellRegistration() -> UICollectionView.CellRegistration<VideoCell, VideoItem> {
        return UICollectionView.CellRegistration<VideoCell, VideoItem> { (cell, indexPath, item) in
            cell.load(with: item)
        }
    }
    
    func makeDataSource() -> DataSource {
        let cellRegistration = cellRegistration()
        
        return UICollectionViewDiffableDataSource<Section, VideoItem>(collectionView: collectionView) {
            
            (collectionView: UICollectionView, indexPath: IndexPath, item: VideoItem) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath, item: item)
        }
    }
    
    func show(_ items: [VideoItem]) {
        self.items = items
        applySnapshot(animatingDifferences: true)
    }
    
    func makeLayoutVideo() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: true)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
