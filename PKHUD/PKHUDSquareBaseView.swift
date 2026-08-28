//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView 正方形 HUD 基础容器视图，具备智能弹性排版能力（单行文本、双行文本或纯图标均能严格实现垂直与水平对称居中）。
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

    /// 主标题标签
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PKHUD.titleFont
        label.textColor = PKHUD.titleColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    /// 副标题标签
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

    /// 重新布局子视图：根据实际内容智能组合并计算垂直对称居中坐标
    open override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = PKHUD.sharedHUD.leadingMargin + PKHUD.sharedHUD.trailingMargin
        let originX: CGFloat = margin > 0 ? margin : 0.0
        let viewWidth = bounds.size.width - 2 * margin
        let viewHeight = bounds.size.height
        let textPadding: CGFloat = 8.0
        let textWidth = max(0, viewWidth - 2 * textPadding)

        let hasTitle = !(titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasSubtitle = !(subtitleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

        if hasTitle && hasSubtitle {
            // 模式 1: 标题 + 图标 + 副标题（三段式全内容，均分对称）
            let titleHeight: CGFloat = 18.0
            let subtitleHeight: CGFloat = 18.0
            let imageSize: CGFloat = 34.0
            let spacing: CGFloat = 6.0
            let totalContentHeight = titleHeight + spacing + imageSize + spacing + subtitleHeight
            let topPadding = max(4.0, (viewHeight - totalContentHeight) / 2.0)

            titleLabel.frame = CGRect(x: originX + textPadding, y: topPadding, width: textWidth, height: titleHeight)
            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: topPadding + titleHeight + spacing, width: imageSize, height: imageSize)
            subtitleLabel.frame = CGRect(x: originX + textPadding, y: topPadding + titleHeight + spacing + imageSize + spacing, width: textWidth, height: subtitleHeight)
        } else if hasSubtitle {
            // 模式 2: 仅副标题 + 图标（最常见的单文本 Loading / 成功提示，整体作为一个组合整体严格垂直对称居中）
            let imageSize: CGFloat = 36.0
            let subtitleHeight: CGFloat = 20.0
            let spacing: CGFloat = 8.0
            let totalContentHeight = imageSize + spacing + subtitleHeight
            let topPadding = (viewHeight - totalContentHeight) / 2.0

            titleLabel.frame = .zero
            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: topPadding, width: imageSize, height: imageSize)
            subtitleLabel.frame = CGRect(x: originX + textPadding, y: topPadding + imageSize + spacing, width: textWidth, height: subtitleHeight)
        } else if hasTitle {
            // 模式 3: 仅主标题 + 图标（整体严格垂直对称居中）
            let titleHeight: CGFloat = 20.0
            let imageSize: CGFloat = 36.0
            let spacing: CGFloat = 8.0
            let totalContentHeight = titleHeight + spacing + imageSize
            let topPadding = (viewHeight - totalContentHeight) / 2.0

            titleLabel.frame = CGRect(x: originX + textPadding, y: topPadding, width: textWidth, height: titleHeight)
            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: topPadding + titleHeight + spacing, width: imageSize, height: imageSize)
            subtitleLabel.frame = .zero
        } else {
            // 模式 4: 纯图标（大图标绝对正中心）
            let imageSize: CGFloat = 44.0
            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: (viewHeight - imageSize) / 2.0, width: imageSize, height: imageSize)
            titleLabel.frame = .zero
            subtitleLabel.frame = .zero
        }
    }
}
