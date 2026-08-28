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
        checkmarkPath.move(to: CGPoint(x: 3.0, y: 20.0))
        checkmarkPath.addLine(to: CGPoint(x: 20.0, y: 37.0))
        checkmarkPath.addLine(to: CGPoint(x: 58.0, y: 0.0))

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0.0, y: 0.0, width: 58.0, height: 37.0)
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
    /// - Parameters:
    ///   - title: 可选主标题
    ///   - subtitle: 可选副标题
    public init(title: String? = nil, subtitle: String? = nil) {
        super.init(title: title, subtitle: subtitle)
        layer.addSublayer(checkmarkShapeLayer)
        checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(checkmarkShapeLayer)
        checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    /// 布局对勾图层位置（严格位于视图正中心）
    open override func layoutSubviews() {
        super.layoutSubviews()
        checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
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
