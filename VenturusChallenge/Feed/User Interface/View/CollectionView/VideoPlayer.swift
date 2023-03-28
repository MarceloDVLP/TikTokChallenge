import AVFoundation
import UIKit

final class VideoPlayer {

    var playerLooper: AVPlayerLooper?
    weak var player: AVPlayer?
    
    func play(_ url: URL, in view: UIView) {
        let playerItem = AVPlayerItem(url: url)
        let player = AVQueuePlayer()
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        self.player = player
        show(player, view)
    }
    
    func stop() {
        playerLooper?.disableLooping()
        player?.pause()
    }
    
    private func show(_ player: AVPlayer,  _ view: UIView) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.frame
        let position: UInt32 = UInt32((view.layer.sublayers?.count) ?? 0)
        view.layer.insertSublayer(playerLayer, at: position)
        player.play()
    }
}
