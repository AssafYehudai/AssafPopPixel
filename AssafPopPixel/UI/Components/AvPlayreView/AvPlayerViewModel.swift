//
//  AvPlayerViewModel.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import AVFoundation
import Combine

class AVPlayerViewModel: ObservableObject {
    
    @Published var avPlayerItem: AVPlayerItem!
    @Published var isPlaying: Bool
    @Published var progressBarValue: Float
    @Published var videoTime: CMTime?
    
    init() {
        isPlaying = false
        progressBarValue = 0
    }
    
    func playButtonTapped() {
        isPlaying = !isPlaying
    }
    
    func setProgress(time: CMTime) {
        progressBarValue = Float(CMTimeGetSeconds(time) / CMTimeGetSeconds(avPlayerItem.duration))
    }
    
    func onUserInteraction(progress: Float) {
        videoTime = CMTimeMultiplyByFloat64(avPlayerItem.duration , multiplier: Float64(progress))
    }
}
