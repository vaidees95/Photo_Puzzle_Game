//
//  Image+Effects.swift
//  PhotoPuzzle
//
//  Created by Vaideeswaran Kaliannan on 10/15/2019.
//  Copyright © 2019 Vaideeswaran Kaliannan. All rights reserved.
//

import UIKit

// crop image
extension UIImage {
    func crop(rect: CGRect) -> UIImage {
        // set params
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
                
        // crop & return the image
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    // crop to square
    func cropToSquare() -> UIImage {
        let imageWidth = self.size.width
        let imageHeight = self.size.height
        let width =  min(imageWidth, imageHeight)
        let height = width
        
        let origin = CGPoint(x: (imageWidth - width) / 2, y: (imageHeight - height) / 2)
        let size = CGSize(width: width, height: height)
        let frame = CGRect(origin: origin, size: size)
        let squareImage = self.crop(rect: frame)
        return squareImage
    }
    
    // resize an image
    // - Attribute: https://gist.github.com/cuxaro/20a5b9bbbccc46180861e01aa7f4a267
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
