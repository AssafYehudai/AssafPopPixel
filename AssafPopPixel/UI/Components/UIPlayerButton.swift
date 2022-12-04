//
//  UIPlayerButton.swift
//  AssafPopPixel
//
//  Created by assaf yehudai on 04/12/2022.
//

import UIKit

class UIPlayerButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTitle("", for: .normal)
    }
    
    func setupPlayButton(isPlaying: Bool) {
        let image: UIImage? = isPlaying ? .pause : .play
        setImage(image, for: .normal)
    }
}
