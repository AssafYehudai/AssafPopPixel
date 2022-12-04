//
//  AssetsMerger.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import Foundation
import AVFoundation

class AssetsMerger {
    
    var onPreviewReady: ((AVPlayerItem) -> ())?
    var composition: AVMutableComposition?
    
    init(onPreviewReady: ((AVPlayerItem) -> Void)? = nil) {
        self.onPreviewReady = onPreviewReady
    }
    
    func mergeVideoAssests(assets: [AVAsset]) {
        composition = AVMutableComposition()
        let videoTrack = composition?.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioTrack = composition?.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        assets.forEach {
            let range = CMTimeRange(start: .zero, duration: $0.duration)
            if let videoAsset = $0.tracks(withMediaType: .video).first,
               let audioAsset = $0.tracks(withMediaType: .audio).first {
                do {
                    try videoTrack?.insertTimeRange(range, of: videoAsset, at: .zero)
                    try audioTrack?.insertTimeRange(range, of: audioAsset, at: .zero)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        guard let preview = composition?.copy() as? AVComposition else { return }
        let item = AVPlayerItem(asset: preview)
        onPreviewReady?(item)
    }
    
    func saveComposition() {
        
    }
}
