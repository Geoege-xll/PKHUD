//
//  PKHUDSystemActivityIndicatorView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSystemActivityIndicatorView 提供基于系统原生 UIActivityIndicatorView 的加载指示器视图。
@MainActor
public final class PKHUDSystemActivityIndicatorView: PKHUDSquareBaseView, PKHUDAnimating {

    /// 初始化系统活动指示器视图
    /// - Parameter title: 可选提示文本
    public init(title: String? = nil) {
        super.init(title: title)
        commonInitIndicator()
    }

    /// 使用指定 Frame 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitIndicator()
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitIndicator()
    }

    func commonInitIndicator() {
        backgroundColor = UIColor.clear
        alpha = 0.95

        addSubview(activityIndicatorView)
    }

    /// 布局指示器中心点
    public override func layoutSubviews() {
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
            activityIndicatorView.center = CGPoint(x: bounds.midX, y: centerY)
        } else {
            activityIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }

    let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = PKHUD.tintColor
        return activity
    }()

    /// 开始动画
    public func startAnimation() {
        activityIndicatorView.startAnimating()
    }

    /// 停止动画
    public func stopAnimation() {
        activityIndicatorView.stopAnimating()
    }
}
