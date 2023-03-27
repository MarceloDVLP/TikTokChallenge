import UIKit
import AVFoundation

final class PhotoCell: UICollectionViewCell {

    var updateCell: ((VideoItem, UIImage) -> ())?
    
    var player: AVPlayer?
    var playerView: UIView = UIView()
    var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .random()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func load(with item: VideoItem) {
        player = AVPlayer(url: item.compressedURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = frame
        playerLayer.videoGravity = .resizeAspectFill
        
        self.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
        player?.play()
    }
}
