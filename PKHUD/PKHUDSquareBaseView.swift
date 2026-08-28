//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView 正方形 HUD 基础容器视图，负责图片与双行文本（标题/副标题）的自适应居中排版。
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

    /// 重新布局子视图（根据是否存在标题/副标题进行自适应黄金居中排版）
    open override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = PKHUD.sharedHUD.leadingMargin + PKHUD.sharedHUD.trailingMargin
        let originX: CGFloat = margin > 0 ? margin : 0.0
        let viewWidth = bounds.size.width - 2 * margin
        let viewHeight = bounds.size.height
        let textPadding: CGFloat = 8.0
        let textWidth = max(0, viewWidth - 2 * textPadding)

        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        let hasSubtitle = !(subtitleLabel.text?.isEmpty ?? true)

        if hasTitle && hasSubtitle {
            let labelHeight: CGFloat = 20.0
            let imageSize: CGFloat = 34.0
            let topPadding = max(6.0, (viewHeight - 2 * labelHeight - imageSize - 16.0) / 2.0)

            titleLabel.frame = CGRect(x: originX + textPadding, y: topPadding, width: textWidth, height: labelHeight)
            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: topPadding + labelHeight + 8.0, width: imageSize, height: imageSize)
            subtitleLabel.frame = CGRect(x: originX + textPadding, y: topPadding + labelHeight + imageSize + 16.0, width: textWidth, height: labelHeight)
        } else if hasSubtitle {
            let imageSize: CGFloat = 40.0
            let labelHeight: CGFloat = 24.0
            let topPadding = max(8.0, (viewHeight - imageSize - labelHeight - 10.0) / 2.0)

            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: topPadding, width: imageSize, height: imageSize)
            subtitleLabel.frame = CGRect(x: originX + textPadding, y: topPadding + imageSize + 10.0, width: textWidth, height: labelHeight)
            titleLabel.frame = .zero
        } else if hasTitle {
            let labelHeight: CGFloat = 24.0
            let imageSize: CGFloat = 40.0
            let topPadding = max(8.0, (viewHeight - labelHeight - imageSize - 10.0) / 2.0)

            titleLabel.frame = CGRect(x: originX + textPadding, y: topPadding, width: textWidth, height: labelHeight)
            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: topPadding + labelHeight + 10.0, width: imageSize, height: imageSize)
            subtitleLabel.frame = .zero
        } else {
            let imageSize: CGFloat = 48.0
            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: (viewHeight - imageSize) / 2.0, width: imageSize, height: imageSize)
            titleLabel.frame = .zero
            subtitleLabel.frame = .zero
        }
    }
}
