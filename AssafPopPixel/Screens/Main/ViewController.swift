//
//  ViewController.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    private var addButtonEnabled: Bool = false {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.navigationItem.rightBarButtonItem?.isEnabled = self?.addButtonEnabled ?? false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorization()
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

