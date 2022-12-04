//
//  ViewController.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var playerView: AvPlayerView!
    
    // MARK: - Properties
    private var pickerDelegate: AssetsPickerDelegate?
    private var assetsMerger: AssetsMerger?
    private lazy var configuration: PHPickerConfiguration =  {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .videos
        configuration.selectionLimit = 2
        return configuration
    }()
    
    private var addButtonEnabled: Bool = false {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.navigationItem.rightBarButtonItem?.isEnabled = self?.addButtonEnabled ?? false
            }
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        title = "Photo Editor"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(openVideoPicker))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                           target: self,
                                                           action: #selector(save))
        checkAuthorization()
        setPickerDelegate()
        setupAssetsMerger()
    }
    
    // MARK: - Selectors
    @objc private func openVideoPicker() {
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = pickerDelegate
        present(picker, animated: true)
    }
    
    @objc private func save() {
        assetsMerger?.saveComposition()
    }
    
    // MARK: - Private Helpers
    private func setPickerDelegate() {
        pickerDelegate = AssetsPickerDelegate(
            onDissmis: { [weak self] in
                self?.dismiss(animated: true)
            },
            onResult: { [weak self] results in
                self?.assetsMerger?.mergeVideoAssests(assets: results.compactMap { $0.asset })
            })
    }
    
    private func setupAssetsMerger() {
        assetsMerger = AssetsMerger(
            onPreviewReady: {[weak self] previewItem in
            DispatchQueue.main.async {
                self?.playerView.setPriview(item: previewItem)
            }
        })
    }
    
    private func checkAuthorization() {
        guard PHPhotoLibrary.authorizationStatus() == .authorized  else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) {[weak self] status in
                self?.addButtonEnabled = (status == .authorized)
            }
            return
        }
        self.addButtonEnabled = true
    }
}

