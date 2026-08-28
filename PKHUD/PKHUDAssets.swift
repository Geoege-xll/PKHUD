//
//  PKHUD.Assets.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/18/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDAssets 提供 HUD 所需的原作者默认静态与动效图标图片资源。
@MainActor
open class PKHUDAssets: NSObject {

    /// 错误叉号图标（读取原作者设计 cross 矢量资源）
    open class var crossImage: UIImage {
        return PKHUDAssets.bundledImage(named: "cross")
    }

    /// 成功对勾图标（读取原作者设计 checkmark 矢量资源）
    open class var checkmarkImage: UIImage {
        return PKHUDAssets.bundledImage(named: "checkmark")
    }

    /// 菊花加载进度图片（读取原作者设计 progress_activity 矢量资源）
    open class var progressActivityImage: UIImage {
        return PKHUDAssets.bundledImage(named: "progress_activity")
    }

    /// 环形加载进度图片（读取原作者设计 progress_circular 矢量资源）
    open class var progressCircularImage: UIImage {
        return PKHUDAssets.bundledImage(named: "progress_circular")
    }

    /// 从对应 Bundle 读取图片资源（兼容 SPM、CocoaPods 及 Framework 架构）
    internal class func bundledImage(named name: String) -> UIImage {
        let primaryBundle = Bundle(for: PKHUDAssets.self)

        #if SWIFT_PACKAGE
        if let image = UIImage(named: name, in: .module, compatibleWith: nil) {
            return image
        }
        #endif

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
