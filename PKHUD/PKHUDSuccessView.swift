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
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: 2.0, y: 15.0))
        checkmarkPath.addLine(to: CGPoint(x: 15.0, y: 28.0))
        checkmarkPath.addLine(to: CGPoint(x: 40.0, y: 0.0))

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 28.0)
        layer.path = checkmarkPath.cgPath

        layer.fillMode = .forwards
        layer.lineCap = .round
        layer.lineJoin = .round

        layer.fillColor = nil
        layer.strokeColor = PKHUD.tintColor.cgColor
        layer.lineWidth = 4.0
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

    /// 布局子视图与对勾图层位置（严格与图片槽位中心对齐）
    open override func layoutSubviews() {
        super.layoutSubviews()

        let hasTitle = !(titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

        if hasTitle {
            let vPadding: CGFloat = 16.0
            let iconSize: CGFloat = 32.0
            let centerY = vPadding + iconSize / 2.0
            checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: centerY)
        } else {
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
