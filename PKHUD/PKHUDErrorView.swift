//
//  PKHUDErrorAnimation.swift
//  PKHUD
//
//  Created by Philip Kluz on 9/27/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDErrorView 提供带有动态旋转弹出动画的错误叉号视图。
@MainActor
open class PKHUDErrorView: PKHUDSquareBaseView, PKHUDAnimating {

    var dashOneLayer = PKHUDErrorView.generateDashLayer()
    var dashTwoLayer = PKHUDErrorView.generateDashLayer()

    class func generateDashLayer() -> CAShapeLayer {
        let dash = CAShapeLayer()
        dash.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        dash.path = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: 22.0))
            path.addLine(to: CGPoint(x: 44.0, y: 22.0))
            return path.cgPath
        }()

        dash.lineCap = .round
        dash.lineJoin = .round
        dash.fillMode = .forwards

        dash.fillColor = nil
        dash.strokeColor = PKHUD.tintColor.cgColor
        dash.lineWidth = 5.0
        return dash
    }

    /// 初始化错误视图
    /// - Parameters:
    ///   - title: 可选主标题
    ///   - subtitle: 可选副标题
    public init(title: String? = nil, subtitle: String? = nil) {
        super.init(title: title, subtitle: subtitle)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
        dashOneLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        dashTwoLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
        dashOneLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        dashTwoLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    /// 布局叉号图层位置（严格位于视图正中心）
    open override func layoutSubviews() {
        super.layoutSubviews()
        dashOneLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        dashTwoLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    /// 深浅色外观切换更新
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        dashOneLayer.strokeColor = PKHUD.tintColor.cgColor
        dashTwoLayer.strokeColor = PKHUD.tintColor.cgColor
    }

    func rotationAnimation(_ angle: CGFloat) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let values: [NSNumber] = [0.0, NSNumber(value: Float(angle * (.pi / 180)))]
        animation.values = values
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }

    /// 开始叉号旋转动画
    open func startAnimation() {
        let dashOneAnimation = rotationAnimation(45.0)
        let dashTwoAnimation = rotationAnimation(-45.0)

        dashOneLayer.transform = CATransform3DMakeRotation(45.0 * (.pi / 180), 0.0, 0.0, 1.0)
        dashTwoLayer.transform = CATransform3DMakeRotation(-45.0 * (.pi / 180), 0.0, 0.0, 1.0)

        dashOneLayer.add(dashOneAnimation, forKey: "dashOneAnimation")
        dashTwoLayer.add(dashTwoAnimation, forKey: "dashTwoAnimation")
    }

    /// 停止动画
    open func stopAnimation() {
        dashOneLayer.removeAnimation(forKey: "dashOneAnimation")
        dashTwoLayer.removeAnimation(forKey: "dashTwoAnimation")
    }
}
