//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView 正方形 HUD 基础容器视图，严格遵循 [图片高度 + 间距 + 文字高度] 整体绝对垂直居中。
@MainActor
open class PKHUDSquareBaseView: UIView {

    /// 默认正方形基础视图 Frame（默认 110 x 110 pt）
    public static var defaultSquareBaseViewFrame: CGRect {
        return CGRect(origin: .zero, size: PKHUD.squareSize)
    }

    /// 使用指定 Frame 初始化视图
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// 便捷初始化正方形 HUD 视图
    /// - Parameters:
    ///   - image: 展示的静态/矢量图标
    ///   - title: 可选提示文本
    public init(image: UIImage? = nil, title: String? = nil) {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        commonInit()
        self.imageView.image = image
        self.titleLabel.text = title
    }

    private func commonInit() {
        addSubview(imageView)
        addSubview(titleLabel)
    }

    /// 居中图标视图
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.85
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = PKHUD.tintColor
        return imageView
    }()

    /// 提示文本标签
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PKHUD.titleFont
        label.textColor = PKHUD.titleColor
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.25
        return label
    }()

    /// 重新布局子视图：严格将 [图片高度 + 间距 + 实际文字高度] 作为一个整体计算垂直水平绝对居中
    open override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = PKHUD.sharedHUD.leadingMargin + PKHUD.sharedHUD.trailingMargin
        let originX: CGFloat = margin > 0 ? margin : 0.0
        let viewWidth = bounds.size.width - 2 * margin
        let viewHeight = bounds.size.height

        let hasTitle = !(titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

        if hasTitle {
            let imageSize: CGFloat = 44.0
            let spacing: CGFloat = 10.0
            let textPadding: CGFloat = 8.0
            let textWidth = max(0, viewWidth - 2 * textPadding)

            // 根据当前字体动态测量文字实际高度
            let calculatedSize = titleLabel.sizeThatFits(CGSize(width: textWidth, height: 40.0))
            let textHeight = max(16.0, min(36.0, ceil(calculatedSize.height)))

            // 核心公式：总内容高度 = 图片高度 + 图文间距 + 文本高度
            let totalContentHeight = imageSize + spacing + textHeight
            
            let topPadding = (viewHeight - totalContentHeight) / 2.0 + 5

            imageView.frame = CGRect(
                x: (viewWidth - imageSize) / 2.0 + originX,
                y: topPadding,
                width: imageSize,
                height: imageSize
            )

            titleLabel.frame = CGRect(
                x: originX + textPadding,
                y: topPadding + imageSize + spacing,
                width: textWidth,
                height: textHeight
            )
        } else {
            // 纯图标模式：50 x 50 pt 大号饱满图标，严格居中锁定在几何正中心 (55, 55)
            let imageSize: CGFloat = 50.0
            imageView.frame = CGRect(
                x: (viewWidth - imageSize) / 2.0 + originX,
                y: (viewHeight - imageSize) / 2.0,
                width: imageSize,
                height: imageSize
            )
            titleLabel.frame = .zero
        }
    }
}
