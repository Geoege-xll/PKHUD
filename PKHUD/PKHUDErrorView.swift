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
        // 大号清晰叉号尺寸 (48 x 48 pt, 线宽 5.0)
        let dash = CAShapeLayer()
        dash.bounds = CGRect(x: 0.0, y: 0.0, width: 48.0, height: 48.0)
        dash.path = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: 24.0))
            path.addLine(to: CGPoint(x: 48.0, y: 24.0))
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
    /// - Parameter title: 可选提示文本
    public init(title: String? = nil) {
        super.init(title: title)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
    }

    /// 布局叉号图层位置（纯图标模式居中锁定，带文字模式严格与图片槽位中心对齐）
    open override func layoutSubviews() {
        super.layoutSubviews()

        let hasTitle = !(titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

        let center: CGPoint
        if hasTitle {
            let imageSize: CGFloat = 42.0
            let spacing: CGFloat = 8.0
            let textPadding: CGFloat = 8.0
            let textWidth = max(0, bounds.width - 2 * textPadding)
            let calculatedSize = titleLabel.sizeThatFits(CGSize(width: textWidth, height: 40.0))
            let textHeight = max(16.0, min(36.0, ceil(calculatedSize.height)))
            let totalContentHeight = imageSize + spacing + textHeight
            let topPadding = (bounds.height - totalContentHeight) / 2.0
            let centerY = topPadding + imageSize / 2.0
            center = CGPoint(x: bounds.midX, y: centerY)

            // 带文字模式：中大号叉号 (39 x 39 pt)
            let scale = CATransform3DMakeScale(0.82, 0.82, 1.0)
            dashOneLayer.transform = CATransform3DConcat(CATransform3DMakeRotation(45.0 * (.pi / 180), 0.0, 0.0, 1.0), scale)
            dashTwoLayer.transform = CATransform3DConcat(CATransform3DMakeRotation(-45.0 * (.pi / 180), 0.0, 0.0, 1.0), scale)
        } else {
            // 纯图标模式：大号饱满叉号 (48 x 48 pt)，居中锁定 (55, 55)
            center = CGPoint(x: bounds.midX, y: bounds.midY)
            dashOneLayer.transform = CATransform3DMakeRotation(45.0 * (.pi / 180), 0.0, 0.0, 1.0)
            dashTwoLayer.transform = CATransform3DMakeRotation(-45.0 * (.pi / 180), 0.0, 0.0, 1.0)
        }

        dashOneLayer.position = center
        dashTwoLayer.position = center
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

        dashOneLayer.add(dashOneAnimation, forKey: "dashOneAnimation")
        dashTwoLayer.add(dashTwoAnimation, forKey: "dashTwoAnimation")
    }

    /// 停止动画
    open func stopAnimation() {
        dashOneLayer.removeAnimation(forKey: "dashOneAnimation")
        dashTwoLayer.removeAnimation(forKey: "dashTwoAnimation")
    }
}
