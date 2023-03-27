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
        collectionView.delegate = self
        collectionView.pinView(in: self)
    }
    
    func cellRegistration() -> UICollectionView.CellRegistration<PhotoCell, VideoItem> {
        return UICollectionView.CellRegistration<PhotoCell, VideoItem> { (cell, indexPath, item) in
            
            cell.load(with: item)
            
            cell.updateCell = { [weak self] item, img in

                guard let self = self else { return }
                
                var updatedSnapshot = self.dataSource.snapshot()
                if let datasourceIndex = updatedSnapshot.indexOfItem(item) {
                    let item = self.items[datasourceIndex]
//                    item.image = img
                    updatedSnapshot.reloadItems([item])
                    self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
                    cell.stopShimmeringEffect()
                }
            }
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
        self.items = [items.first!]
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
    
    func makeLayout() -> UICollectionViewLayout {
        let inset: CGFloat = 2.5
        
        // Items
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Nested Group
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [smallItem])
        
        // Outer Group
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.7))
        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [largeItem, nestedGroup, nestedGroup])
        
        // Section
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
                 
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func showLoadingItems(numberOfItems: Int = 20) {
        guard !self.items.contains(where: { type(of: $0) == PhotoLoading.self }) else { return }
        
        for _ in 0...numberOfItems {
//            items += [VideoItem()]
        }
        
        applySnapshot(animatingDifferences: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension PhotoGalleryView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
          return
        }
        didSelect?(item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let didScroll = (scrollView.contentOffset.y) >= (scrollView.contentSize.height - scrollView.bounds.size.height)
        let hasOnlyLoadingItems = self.items.allSatisfy({ type(of: $0) == PhotoLoading.self })
                                    
        if (didScroll) && (!hasOnlyLoadingItems) {
//            showLoadingItems()
//            didScrollToTheEnd?()
       }
   }
}


