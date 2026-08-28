//
//  PKHUD.Assets.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/18/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDAssets 提供 HUD 所需的默认图标与图片资源（优先使用系统原生 SF Symbols 矢量，具备优秀的清晰度与深浅色模式自适应能力）。
@MainActor
open class PKHUDAssets: NSObject {

    /// SF Symbol 默认符号排版配置（默认 28pt semibold）
    public static var symbolConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 28.0, weight: .semibold)

    /// 错误叉号图标
    open class var crossImage: UIImage {
        if let sfImage = UIImage(systemName: "xmark", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate) {
            return sfImage
        }
        return PKHUDAssets.bundledImage(named: "cross")
    }

    /// 成功对勾图标
    open class var checkmarkImage: UIImage {
        if let sfImage = UIImage(systemName: "checkmark", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate) {
            return sfImage
        }
        return PKHUDAssets.bundledImage(named: "checkmark")
    }

    /// 菊花加载进度图片
    open class var progressActivityImage: UIImage {
        return PKHUDAssets.bundledImage(named: "progress_activity")
    }

    /// 环形加载进度图片
    open class var progressCircularImage: UIImage {
        return PKHUDAssets.bundledImage(named: "progress_circular")
    }

    /// 从内部 Bundle 读取图片资源
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
