//
//  PKHUDCheckmarkView.swift
//  PKHUD
//
//  Created by Philip Kluz on 9/27/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSuccessView 提供带有动态绘制动画的成功对勾视图。
@MainActor
open class PKHUDSuccessView: PKHUDSquareBaseView, PKHUDAnimating {

    var checkmarkShapeLayer: CAShapeLayer = {
        // 大号清晰对勾路径 (60 x 39 pt)
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: 3.0, y: 19.0))
        checkmarkPath.addLine(to: CGPoint(x: 23.0, y: 39.0))
        checkmarkPath.addLine(to: CGPoint(x: 60.0, y: 0.0))

        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 39.0)
        layer.path = checkmarkPath.cgPath

        layer.fillMode = .forwards
        layer.lineCap = .round
        layer.lineJoin = .round

        layer.fillColor = nil
        layer.strokeColor = PKHUD.tintColor.cgColor
        layer.lineWidth = 5.0
        return layer
    }()

    /// 初始化成功视图
    /// - Parameter title: 可选提示文本
    public init(title: String? = nil) {
        super.init(title: title)
        layer.addSublayer(checkmarkShapeLayer)
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(checkmarkShapeLayer)
    }

    /// 布局对勾图层位置（纯图标模式居中锁定，带文字模式严格与图片槽位中心对齐）
    open override func layoutSubviews() {
        super.layoutSubviews()

        let hasTitle = !(titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

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

            // 带文字模式：中大号对勾 (50 x 32 pt)
            checkmarkShapeLayer.transform = CATransform3DMakeScale(0.82, 0.82, 1.0)
            checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: centerY)
        } else {
            // 纯图标模式：大号饱满对勾 (60 x 39 pt)，居中锁定 (55, 55)
            checkmarkShapeLayer.transform = CATransform3DIdentity
            checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }

    /// 深浅色外观切换更新
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        checkmarkShapeLayer.strokeColor = PKHUD.tintColor.cgColor
    }

    /// 开始对勾绘制动画
    open func startAnimation() {
        let checkmarkStrokeAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        checkmarkStrokeAnimation.values = [0, 1]
        checkmarkStrokeAnimation.keyTimes = [0, 1]
        checkmarkStrokeAnimation.duration = 0.35

        checkmarkShapeLayer.add(checkmarkStrokeAnimation, forKey: "checkmarkStrokeAnim")
    }

    /// 停止动画
    open func stopAnimation() {
        checkmarkShapeLayer.removeAnimation(forKey: "checkmarkStrokeAnimation")
    }
}
