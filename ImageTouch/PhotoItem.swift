//
//  PhotoItem.swift
//  ImageTouch
//
//  Created by Madji on 26.01.21.
//

import Foundation
import UIKit

struct PhotoItem {
    
    struct DefaultSize {
        static let width: CGFloat = 140.0 // Size of cell
        static let height: CGFloat = 140.0
    }
    
    var image: UIImage?
    var urlString: String?
    var imageData: NSData?

    //MARK: - Compute property needed for size of cell
    var scaledSize: CGSize {
    
        guard let image = image else {
            return CGSize(width: DefaultSize.width,
                          height: DefaultSize.height)
        }
        
        let scaleFactor = UIScreen.main.scale
        let widthHeightRatio = image.size.width / image.size.height
        var scaledWidth = ceil(image.size.width / scaleFactor)
        var scaledHeight = ceil(image.size.height / scaleFactor)
        
        if scaledHeight > DefaultSize.height {
            scaledHeight = DefaultSize.height
            scaledWidth = scaledHeight * widthHeightRatio
        }
        
        return CGSize(width: scaledWidth, height: scaledHeight)
    }

}


