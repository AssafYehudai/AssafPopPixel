//
//  AvAssetConverter.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import AVFoundation
import PhotosUI

class AvAssestConverter {
    // MARK: - Types
    typealias ConversionAsset = (asset: AVAsset?,audio: AVAudioMix?, info: [AnyHashable : Any]?)
    typealias ConversionBlock = ([ConversionAsset]) -> ()
    
    // MARK: - Properties
    private var results = [ConversionAsset]()
    private var dispatchGroup: DispatchGroup?
    
    // MARK: - Public Api
    func convert(from phAssets:[PHAsset], completion: ConversionBlock?) {
        dispatchGroup = DispatchGroup()
        let options = PHVideoRequestOptions()
        options.version = .original

        phAssets.forEach {
            dispatchGroup?.enter()
            PHImageManager.default().requestAVAsset(forVideo: $0, options: options) { [weak self] (asset, audio, info) in
                self?.results.append(ConversionAsset(asset, audio, info))
                self?.dispatchGroup?.leave()
            }
        }
        
        dispatchGroup?.notify(queue: .global()) {[weak self] in
            guard let result = self?.results else { return }
            completion?(result)
        }
    }
}
