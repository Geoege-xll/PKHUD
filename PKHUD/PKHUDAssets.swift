//
//  PKHUD.Assets.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/18/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDAssets provides a set of default images that can be supplied to the PKHUD's content views.
@MainActor
open class PKHUDAssets: NSObject {

    public static var symbolConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 28.0, weight: .semibold)

    open class var crossImage: UIImage {
        if let sfImage = UIImage(systemName: "xmark", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate) {
            return sfImage
        }
        return PKHUDAssets.bundledImage(named: "cross")
    }

    open class var checkmarkImage: UIImage {
        if let sfImage = UIImage(systemName: "checkmark", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate) {
            return sfImage
        }
        return PKHUDAssets.bundledImage(named: "checkmark")
    }

    open class var progressActivityImage: UIImage {
        return PKHUDAssets.bundledImage(named: "progress_activity")
    }

    open class var progressCircularImage: UIImage {
        return PKHUDAssets.bundledImage(named: "progress_circular")
    }

    internal class func bundledImage(named name: String) -> UIImage {
        #if SWIFT_PACKAGE
        if let image = UIImage(named: name, in: .module, compatibleWith: nil) {
            return image
        }
        #endif

        let primaryBundle = Bundle(for: PKHUDAssets.self)
        if let image = UIImage(named: name, in: primaryBundle, compatibleWith: nil) {
            return image
        } else if
            let subBundleUrl = primaryBundle.url(forResource: "PKHUDResources", withExtension: "bundle"),
            let subBundle = Bundle(url: subBundleUrl),
            let image = UIImage(named: name, in: subBundle, compatibleWith: nil) {
            return image
        }

        return UIImage()
    }
}
