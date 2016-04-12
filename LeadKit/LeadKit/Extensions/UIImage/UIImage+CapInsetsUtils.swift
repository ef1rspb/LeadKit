//
//  UIImage+CapInsetsUtils.swift
//  LeadKit
//
//  Created by Иван Смолин on 09/04/16.
//  Copyright © 2016 Touch Instinct. All rights reserved.
//

import UIKit

extension UIImage {

    /**
     method which render current UIImage for specific size and return new UIImage
     
     - parameter size: size of new rendered image
     
     - returns: new rendered UIImage
     */
    public func renderWithSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        self.drawInRect(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return resizedImage
    }

    /**
     this method tries to find requested image with specific parameters in cache, and if doesn't exists - create it
     
     - parameter name:      name of the image used in UIImage(named:)
     - parameter size:      size of rendered image
     - parameter capInsets: cap insets for image
     - parameter cache:     cache to search
     
     - returns: cached or newly created image or nil if no such image find with specified name
     */
    public static func fetchOrCreateImageWithName(name: String,
                                                  size: CGSize,
                                                  capInsets: UIEdgeInsets,
                                                  cache: NSCache) -> UIImage? {
        let cacheKey = "\(name)-\(NSStringFromUIEdgeInsets(capInsets))-\(NSStringFromCGSize(size))"

        if let cachedImage = cache.objectForKey(cacheKey) as? UIImage {
            return cachedImage
        }

        if let renderedImage = UIImage(named: name)?.resizableImageWithCapInsets(capInsets).renderWithSize(size) {
            cache.setObject(renderedImage, forKey: cacheKey)

            return renderedImage
        }

        return nil
    }

    /**
     this metho tries to find requested image with specific parameters in cache, and if doesn't exists - create it
     
     - parameter name:                  name of the image used in UIImage(named:)
     - parameter size:                  size of rendered image
     - parameter assetsInsetsForScales: mapping of screen scale to UIEdgeInsets which defined in XCAssets
     - parameter cache:                 cache to search
     
     - returns: cached or newly created image or nil if no such image find with specified name
     */
    public static func fetchOrCreateImageWithName(name: String,
                                                  size: CGSize,
                                                  assetsInsetsForScales: [CGFloat: UIEdgeInsets],
                                                  cache: NSCache) -> UIImage? {
        let scale = UIScreen.mainScreen().scale

        if let assetsInsetsForScale = assetsInsetsForScales[scale] {
            let capInsetsForScale = UIEdgeInsets(top: assetsInsetsForScale.top / scale,
                                                 left: assetsInsetsForScale.left / scale,
                                                 bottom: assetsInsetsForScale.bottom / scale,
                                                 right: assetsInsetsForScale.right / scale)
            

            return self.fetchOrCreateImageWithName(name, size: size, capInsets: capInsetsForScale, cache: cache)
        }

        return nil
    }

}
