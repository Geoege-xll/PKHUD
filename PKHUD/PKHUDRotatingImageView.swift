//
//  PKHUDRotatingImageView.swift
//  PKHUD
//
//  Created by Mark Koh on 1/14/16.
//  Copyright © 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit
import QuartzCore

/// PKHUDRotatingImageView 旋转图片视图，使传入的图片自动执行 360 度连续旋转动画。
@MainActor
open class PKHUDRotatingImageView: PKHUDSquareBaseView, PKHUDAnimating {

    /// 开始连续旋转动画
    public func startAnimation() {
        imageView.layer.add(PKHUDAnimation.continuousRotation, forKey: "progressAnimation")
    }

    /// 停止旋转动画
    public func stopAnimation() {
        imageView.layer.removeAnimation(forKey: "progressAnimation")
    }
}
