//
//  AvPlayerView.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import UIKit
import AVFoundation
import Combine

class AvPlayerView: UIView, Nibable {
    
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - IBOutlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var playerContainer: UIView!
    @IBOutlet weak var playButton: UIPlayerButton!
    @IBOutlet weak var progressBar: UISlider!
    
    // MARK: - Properties
    private var viewModel: AVPlayerViewModel!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    // MARK: - Constuctor
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(bundle: .main)
        setupPlayer()
        setViewModel(viewModel: AVPlayerViewModel())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = playerContainer.bounds
    }
    
    // MARK: - Public Api
    func setup(item: AVPlayerItem?) {
        viewModel.avPlayerItem = item
    }
    
    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: Any) {
        viewModel?.playButtonTapped()
    }
    
    @IBAction func onUserSlide(_ sender: UISlider) {
        viewModel.onUserInteraction(progress: sender.value)
    }
    
    // MARK: - Private Helpers
    private func setViewModel(viewModel: AVPlayerViewModel) {
        self.viewModel = viewModel
        viewModel.$avPlayerItem
            .receive(on: DispatchQueue.main)
            .sink {[weak self] item in
                self?.player.replaceCurrentItem(with: item)
            }.store(in: &subscriptions)
        viewModel.$isPlaying
            .receive(on: DispatchQueue.main)
            .sink {[weak self] isPlaying in
                isPlaying ? self?.player.play() : self?.player.pause()
                self?.playButton.setupPlayButton(isPlaying: isPlaying)
            }.store(in: &subscriptions)
        viewModel.$progressBarValue
            .receive(on: DispatchQueue.main)
            .sink {[weak self] progress in
                self?.progressBar.setValue(progress, animated: true)
            }.store(in: &subscriptions)
        viewModel.$videoTime
            .receive(on: DispatchQueue.main)
            .sink {[weak self] time in
                guard let time = time else { return }
                self?.player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
            }.store(in: &subscriptions)
    }
    
    private func setupPlayer() {
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.needsDisplayOnBoundsChange = true
        let affineTransform = CGAffineTransform(rotationAngle: .pi * 0.5)
        playerLayer.setAffineTransform(affineTransform)
        playerContainer.layer.addSublayer(playerLayer)
        
        let interval = CMTime(value: CMTimeValue(1), timescale: CMTimeScale(1))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] progress in
            self?.viewModel.setProgress(time: progress)
        }
    }
}
