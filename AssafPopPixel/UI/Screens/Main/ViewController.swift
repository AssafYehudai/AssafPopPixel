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
    
    private var saveButtonEnabled: Bool = false {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.navigationItem.leftBarButtonItem?.isEnabled = self?.saveButtonEnabled ?? false
            }
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        title = "Video Editor"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(openVideoPicker))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                           target: self,
                                                           action: #selector(save))
        saveButtonEnabled = false
        setPickerDelegate()
        setupAssetsMerger()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
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
                self?.saveButtonEnabled = true
                self?.assetsMerger?.mergeVideoAssests(assets: results.compactMap { $0.asset })
            })
    }
    
    private func setupAssetsMerger() {
        assetsMerger = AssetsMerger(
            onPreviewReady: {[weak self] previewItem in
                DispatchQueue.main.async {
                    self?.playerView.setup(item: previewItem)
                }
            },
            onFinishSave: {[weak self] in
                DispatchQueue.main.async {
                    self?.onVideoSaved()
                }
            })
    }
    
    private func checkAuthorization() {
        guard PHPhotoLibrary.authorizationStatus() == .authorized  else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) {[unowned self] status in
                self.addButtonEnabled = (status == .authorized)
                if status != .authorized {
                    Alerts.showAuthorizationAlert(vc: self)
                }
            }
            return
        }
        self.addButtonEnabled = true
    }
    
    private func onVideoSaved() {
        Alerts.showSaveAlert(vc: self) {[weak self] in
            DispatchQueue.main.async {
                self?.saveButtonEnabled = false
                self?.playerView.setup(item: nil)
            }
        }
    }
}

