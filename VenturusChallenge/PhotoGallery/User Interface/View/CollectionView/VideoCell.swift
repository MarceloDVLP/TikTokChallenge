import UIKit
import AVFoundation

final class VideoCell: UICollectionViewCell {

    var updateCell: ((VideoItem, UIImage) -> ())?
    
    var playerView: UIView = UIView()
    var player: AVQueuePlayer!
    var playerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper!
    
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
        stop()
    }
    
    func load(with item: VideoItem) {
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        let playerItem = AVPlayerItem(url: item.compressedURL)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        player.play()
        
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = contentView.frame
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.backgroundColor = UIColor.black.cgColor
        self.contentView.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
        player?.play()
    }
    
    func stop() {
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player?.pause()
        playerLooper.disableLooping()
        player = nil
    }
    
    func play() {
        player?.play()
    }
}
