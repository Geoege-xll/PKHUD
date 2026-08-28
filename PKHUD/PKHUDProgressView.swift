//
//  PKHUDProgressView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit
import QuartzCore

/// PKHUDProgressView 提供基于图片离散/平滑旋转的不确定进度（Loading 菊花）视图。
@MainActor
open class PKHUDProgressView: PKHUDSquareBaseView, PKHUDAnimating {

    /// 初始化进度视图
    /// - Parameters:
    ///   - title: 可选主标题
    ///   - subtitle: 可选副标题
    public init(title: String? = nil, subtitle: String? = nil) {
        super.init(image: PKHUDAssets.progressActivityImage, title: title, subtitle: subtitle)
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// 开始旋转动画
    public func startAnimation() {
        imageView.layer.add(PKHUDAnimation.discreteRotation, forKey: "progressAnimation")
    }

    /// 停止旋转动画
    public func stopAnimation() {
        imageView.layer.removeAnimation(forKey: "progressAnimation")
    }
}
