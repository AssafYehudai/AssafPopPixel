//
//  AssetsPickerDelegate.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import PhotosUI

class AssetsPickerDelegate: PHPickerViewControllerDelegate {
    
    // MARK: - Properties
    private var onDissmis: (() -> ())?
    private var onResult: (([AvAssestConverter.ConversionAsset]) -> ())?
    private var converter: AvAssestConverter?
    
    // MARK: - Constructor
    init(onDissmis: (() -> Void)? ,
         onResult: (([AvAssestConverter.ConversionAsset]) -> Void)?) {
        self.onDissmis = onDissmis
        self.onResult = onResult
    }
    
    // MARK: - Public Api
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        onDissmis?()
        guard !results.isEmpty else { return }
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: results.compactMap{ $0.assetIdentifier }, options: nil)
        let assetsArray = assets.objects(at: IndexSet(0...assets.count-1))
        handle(results: assetsArray)
    }
    
    // MARK: - Private Helpers
    private func handle(results: [PHAsset]) {
        converter = AvAssestConverter()
        converter?.convert(from: results) {[weak self] assets in
            DispatchQueue.main.async {
                self?.onResult?(assets)
            }
        }
    }
}
