//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView 正方形 HUD 基础容器视图，采用经典的三段式黄金比例排版（顶部标题、中间居中图标、底部副标题）。
@MainActor
open class PKHUDSquareBaseView: UIView {

    /// 默认正方形基础视图 Frame
    public static var defaultSquareBaseViewFrame: CGRect {
        return CGRect(origin: .zero, size: PKHUD.squareSize)
    }

    /// 使用指定 Frame 初始化视图
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// 便捷初始化正方形 HUD 视图
    /// - Parameters:
    ///   - image: 展示的静态/矢量图标
    ///   - title: 可选主标题文本
    ///   - subtitle: 可选副标题文本
    public init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        self.imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    /// 居中图标视图
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = PKHUD.tintColor
        return imageView
    }()

    /// 主标题标签（固定位于顶部 1/4 区域）
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PKHUD.titleFont
        label.textColor = PKHUD.titleColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    /// 副标题标签（固定位于底部 1/4 区域）
    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PKHUD.subtitleFont
        label.textColor = PKHUD.subtitleColor
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.25
        return label
    }()

    /// 重新布局子视图：严格遵循三段式排版，图标始终锁定在 HUD 几何正中心 (bounds.midX, bounds.midY)
    open override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = PKHUD.sharedHUD.leadingMargin + PKHUD.sharedHUD.trailingMargin
        let originX: CGFloat = margin > 0 ? margin : 0.0
        let viewWidth = bounds.size.width - 2 * margin
        let viewHeight = bounds.size.height
        let textPadding: CGFloat = 6.0
        let textWidth = max(0, viewWidth - 2 * textPadding)

        let quarterHeight = ceil(viewHeight / 4.0)
        let threeQuarterHeight = viewHeight - quarterHeight

        // 1. 顶部标题槽位（占顶部 1/4）
        titleLabel.frame = CGRect(x: originX + textPadding, y: 4.0, width: textWidth, height: quarterHeight - 4.0)

        // 2. 中间图标槽位（始终锁定在卡片几何正中心）
        let hasText = !(titleLabel.text?.isEmpty ?? true) || !(subtitleLabel.text?.isEmpty ?? true)
        let iconSize: CGFloat = hasText ? 38.0 : 48.0
        imageView.frame = CGRect(
            x: (viewWidth - iconSize) / 2.0 + originX,
            y: (viewHeight - iconSize) / 2.0,
            width: iconSize,
            height: iconSize
        )

        // 3. 底部副标题槽位（占底部 1/4）
        subtitleLabel.frame = CGRect(x: originX + textPadding, y: threeQuarterHeight - 2.0, width: textWidth, height: quarterHeight)
    }
}
