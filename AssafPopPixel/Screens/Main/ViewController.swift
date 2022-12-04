//
//  ViewController.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    // MARK: - Properties
    private var pickerDelegate: AssetsPickerDelegate?
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
                                                            action: #selector(addVideos))
        checkAuthorization()
    }
    
    // MARK: - Private Helpers
    @objc private func addVideos() {
        pickerDelegate = AssetsPickerDelegate(
            onDissmis: { [weak self] in
                self?.dismiss(animated: true)
            },
            onResult: { [weak self] results in
                print(results.count)
            })
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = pickerDelegate
        present(picker, animated: true)
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

