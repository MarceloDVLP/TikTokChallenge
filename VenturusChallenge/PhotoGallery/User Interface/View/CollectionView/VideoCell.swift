import UIKit
import AVFoundation

final class VideoCell: UICollectionViewCell {
    
    private var videoPlayer = VideoPlayer()
    private var task: URLSessionDataTask?
    private var item: VideoItem?
    
    private lazy var userLabel = {
        let userLabel = UILabel()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.font = UIFont.boldSystemFont(ofSize: 18)
        userLabel.textColor = .white
        return userLabel
    }()

    private lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private lazy var profileImageView = {
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        return profileImageView
    }()
    
    private lazy var heartImageView = {
        let heartImageView = UIImageView(image: UIImage(named: "heart_on")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.clipsToBounds = true
        heartImageView.contentMode = .scaleAspectFit
        return heartImageView
    }()
    
    private lazy var likeImageView = {
        let likeImageView = UIImageView(image: UIImage(named: "like_on")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.clipsToBounds = true
        likeImageView.contentMode = .scaleAspectFit
        return likeImageView
    }()
    
    private lazy var countHeartLabel = {
        let countHeartLabel = UILabel()
        countHeartLabel.translatesAutoresizingMaskIntoConstraints = false
        countHeartLabel.font = UIFont.boldSystemFont(ofSize: 18)
        countHeartLabel.textColor = .white
        countHeartLabel.text = "23"
        return countHeartLabel
    }()
    
    private lazy var countLikeLabel = {
        let countLikeLabel = UILabel()
        countLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        countLikeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        countLikeLabel.textColor = .white
        countLikeLabel.text = "492"
        return countLikeLabel
    }()
    
    private lazy var darkLayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constrainSubViews()
        addTapGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoPlayer.stop()
        task?.cancel()
        item = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = 24
    }
    
    func load(with item: VideoItem) {
        self.item = item
        videoPlayer.play(item.compressedURL, in: contentView)
        titleLabel.text = item.body
        userLabel.text = item.username
        loadImage(item.profileURL)
        bringSubviewsToFront()
        
        if item.isFavorite {
            heartImageView.image = heartImageView.image?.withTintColor(.red.withAlphaComponent(0.8), renderingMode: .alwaysOriginal)
        } else {
            heartImageView.image = heartImageView.image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
        
        countLikeLabel.text = String(item.likes)
        countHeartLabel.text = String(item.favoriteCount)
    }
    
    func bringSubviewsToFront() {
        contentView.bringSubviewToFront(darkLayer)
        contentView.bringSubviewToFront(titleLabel)
        contentView.bringSubviewToFront(userLabel)
        contentView.bringSubviewToFront(profileImageView)
        contentView.bringSubviewToFront(likeImageView)
        contentView.bringSubviewToFront(heartImageView)
        contentView.bringSubviewToFront(countLikeLabel)
        contentView.bringSubviewToFront(countHeartLabel)
    }
    
    func loadImage(_ url: URL) {
        DispatchQueue.global().async { [weak self] in
            self?.task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                DispatchQueue.main.async { [weak self] in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    self?.profileImageView.image = image
                }
            })
            self?.task?.resume()
        }
    }
    
    func addSubviews() {
        contentView.addSubview(userLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(darkLayer)
        contentView.addSubview(likeImageView)
        contentView.addSubview(heartImageView)
        contentView.addSubview(countLikeLabel)
        contentView.addSubview(countHeartLabel)
    }
    
    func constrainSubViews() {
        darkLayer.pinView(in: contentView)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 64),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            

            userLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            userLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -200),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            heartImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heartImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            heartImageView.widthAnchor.constraint(equalToConstant: 30),
            heartImageView.heightAnchor.constraint(equalToConstant: 30),

            likeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeImageView.widthAnchor.constraint(equalToConstant: 30),
            likeImageView.heightAnchor.constraint(equalToConstant: 30),
            
            countLikeLabel.topAnchor.constraint(equalTo: likeImageView.bottomAnchor, constant: 8),
            countLikeLabel.centerXAnchor.constraint(equalTo: likeImageView.centerXAnchor),

            countHeartLabel.topAnchor.constraint(equalTo: heartImageView.bottomAnchor, constant: 8),
            countHeartLabel.centerXAnchor.constraint(equalTo: heartImageView.centerXAnchor)
        ])
    }
    
    func addTapGestures() {
        heartImageView.isUserInteractionEnabled = true
        heartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFavorite)))
        
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLike)))
    }
    
    @objc func didTapFavorite() {
        guard let item = self.item else { return }
        item.favorite()
        
        if item.isFavorite {
            heartImageView.image = heartImageView.image?.withTintColor(.red.withAlphaComponent(0.8), renderingMode: .alwaysOriginal)
        } else {
            heartImageView.image = heartImageView.image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
        countHeartLabel.text = String(item.favoriteCount)
    }
    
    @objc func didTapLike() {
        guard let item = self.item else { return }
        item.like()
        countLikeLabel.text = String(item.likes)
    }
}


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
