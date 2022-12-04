//
//  AvPlayerView.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import UIKit
import AVFoundation

class AvPlayerView: UIView {

    private var player: AVPlayer!
    private var isPlaynig = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds        
        let affineTransform = CGAffineTransform(rotationAngle: .pi * 0.5)
        playerLayer.setAffineTransform(affineTransform)
        layer.addSublayer(playerLayer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        addGestureRecognizer(tapGesture)
    }
    
    func setPriview(item: AVPlayerItem) {
        player.replaceCurrentItem(with: item)
    }
    
    @objc func playVideo() {
        if isPlaynig {
            player.pause()
        } else {
            player.play()
        }
        isPlaynig = !isPlaynig
    }
}
