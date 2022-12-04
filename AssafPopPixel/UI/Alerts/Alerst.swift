//
//  Alerst.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import UIKit

struct Alerts {
    
    static func showSaveAlert(vc: UIViewController, completion: (() -> Void)? ) {
        let alert = UIAlertController(title: nil, message: "Save Success", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            completion?()
        })
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showAuthorizationAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Access To Camera Roll Needed",
                                      message: "Please go app setting and set permission",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}
