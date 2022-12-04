//
//  AssetsMerger.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import Foundation
import AVFoundation
import PhotosUI

class AssetsMerger: NSObject {
    
    // MARK: - Binders
    var onPreviewReady: ((AVPlayerItem) -> ())?
    var onFinishSave: (() -> ())?
    
    // MARK: - Propeties
    var composition: AVMutableComposition?
    
    // MARK: - Constructor
    init(onPreviewReady: ((AVPlayerItem) -> Void)? = nil,
         onFinishSave: (() -> Void)? = nil) {
        self.onPreviewReady = onPreviewReady
        self.onFinishSave = onFinishSave
    }
    
    // MARK: - Public Api
    func mergeVideoAssests(assets: [AVAsset]) {
        composition = AVMutableComposition()
        let videoTrack = composition?.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioTrack = composition?.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        assets.forEach {
            let range = CMTimeRange(start: .zero, duration: $0.duration)
            if let videoAsset = $0.tracks(withMediaType: .video).first,
               let audioAsset = $0.tracks(withMediaType: .audio).first {
                videoTrack?.preferredTransform = videoAsset.preferredTransform
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
        guard let asset = composition else { return }
        let exportPath = NSTemporaryDirectory().appendingFormat("/video.mov")
        let exportURL = URL(fileURLWithPath: exportPath)
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputURL = exportURL
        exporter?.outputFileType = .mov
        exporter?.exportAsynchronously {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportURL)
            }) {[weak self] saved, error in
                if saved {
                    self?.onFinishSave?()
                }
            }
        }
    }
}
