//
//  PKHUDAnimation.swift
//  PKHUD
//
//  Created by Piergiuseppe Longo on 06/01/16.
//  Copyright © 2016 Piergiuseppe Longo, NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import Foundation
import QuartzCore

/// PKHUDAnimation 预置的核心动画工厂类，提供离散旋转及平滑连续旋转的核心动画实例。
public final class PKHUDAnimation: Sendable {

    /// 12 段离散跳跃旋转动画（常用于经典 iOS 系统菊花 Loading 效果）
    public static let discreteRotation: CAAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [
            NSNumber(value: 0.0),
            NSNumber(value: 1.0 * .pi / 6.0),
            NSNumber(value: 2.0 * .pi / 6.0),
            NSNumber(value: 3.0 * .pi / 6.0),
            NSNumber(value: 4.0 * .pi / 6.0),
            NSNumber(value: 5.0 * .pi / 6.0),
            NSNumber(value: 6.0 * .pi / 6.0),
            NSNumber(value: 7.0 * .pi / 6.0),
            NSNumber(value: 8.0 * .pi / 6.0),
            NSNumber(value: 9.0 * .pi / 6.0),
            NSNumber(value: 10.0 * .pi / 6.0),
            NSNumber(value: 11.0 * .pi / 6.0),
            NSNumber(value: 2.0 * .pi)
        ]
        animation.keyTimes = [
            NSNumber(value: 0.0),
            NSNumber(value: 1.0 / 12.0),
            NSNumber(value: 2.0 / 12.0),
            NSNumber(value: 3.0 / 12.0),
            NSNumber(value: 4.0 / 12.0),
            NSNumber(value: 5.0 / 12.0),
            NSNumber(value: 0.5),
            NSNumber(value: 7.0 / 12.0),
            NSNumber(value: 8.0 / 12.0),
            NSNumber(value: 9.0 / 12.0),
            NSNumber(value: 10.0 / 12.0),
            NSNumber(value: 11.0 / 12.0),
            NSNumber(value: 1.0)
        ]
        animation.duration = 1.2
        animation.calculationMode = .discrete
        animation.repeatCount = Float(INT_MAX)
        return animation
    }()

    /// 360 度平滑连续匀速旋转动画（常用于圆环或自定义图标旋转 Loading）
    public static let continuousRotation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2.0 * .pi
        animation.duration = 1.2
        animation.repeatCount = Float(INT_MAX)
        return animation
    }()
}
