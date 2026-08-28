//
//  HUDView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/16/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// FrameView 提供 HUD 的毛玻璃背景容器、连续平滑圆角以及倾斜视差（Motion Effect）动效。
@MainActor
open class FrameView: UIVisualEffectView {

    /// 毛玻璃卡片圆角大小（默认 16.0 pt）
    open var cornerRadius: CGFloat = 16.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    /// 初始化 FrameView，默认使用系统自适应材质毛玻璃
    public init() {
        super.init(effect: UIBlurEffect(style: .systemMaterial))
        commonInit()
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        clipsToBounds = true

        contentView.addSubview(content)

        let offset = 20.0

        let motionEffectsX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        motionEffectsX.maximumRelativeValue = offset
        motionEffectsX.minimumRelativeValue = -offset

        let motionEffectsY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        motionEffectsY.maximumRelativeValue = offset
        motionEffectsY.minimumRelativeValue = -offset

        let group = UIMotionEffectGroup()
        group.motionEffects = [motionEffectsX, motionEffectsY]

        addMotionEffect(group)
    }

    private var _content = UIView()

    /// 承载的实际内容视图（赋值时会自动同步 FrameView 的大小）
    open var content: UIView {
        get {
            return _content
        }
        set {
            _content.removeFromSuperview()
            _content = newValue
            _content.clipsToBounds = true
            _content.contentMode = .center
            frame.size = _content.bounds.size
            contentView.addSubview(_content)
        }
    }
}
