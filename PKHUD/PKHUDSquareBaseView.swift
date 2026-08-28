//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView 正方形 HUD 基础容器视图，负责图标与单段文本的高性能自适应垂直居中排版。
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
    ///   - title: 可选提示文本
    public init(image: UIImage? = nil, title: String? = nil) {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        self.imageView.image = image
        titleLabel.text = title

        addSubview(imageView)
        addSubview(titleLabel)
    }

    /// 居中图标视图
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = PKHUD.tintColor
        return imageView
    }()

    /// 提示文本标签（支持最多 2 行自适应缩放）
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

    /// 重新布局子视图：严格根据是否有提示文本进行垂直黄金对称居中排版
    open override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = PKHUD.sharedHUD.leadingMargin + PKHUD.sharedHUD.trailingMargin
        let originX: CGFloat = margin > 0 ? margin : 0.0
        let viewWidth = bounds.size.width - 2 * margin
        let viewHeight = bounds.size.height
        let textPadding: CGFloat = 8.0
        let textWidth = max(0, viewWidth - 2 * textPadding)

        let hasTitle = !(titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

        if hasTitle {
            // 模式 1: 图标 + 文本（整体严格垂直对称居中：顶部留白 23pt = 底部留白 23pt）
            let imageSize: CGFloat = 32.0
            let titleHeight: CGFloat = 20.0
            let spacing: CGFloat = 12.0
            let totalContentHeight = imageSize + spacing + titleHeight
            let topPadding = (viewHeight - totalContentHeight) / 2.0

            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: topPadding, width: imageSize, height: imageSize)
            titleLabel.frame = CGRect(x: originX + textPadding, y: topPadding + imageSize + spacing, width: textWidth, height: titleHeight)
        } else {
            // 模式 2: 纯图标（大图标绝对锁定在卡片几何正中心）
            let imageSize: CGFloat = 42.0
            imageView.frame = CGRect(x: (viewWidth - imageSize) / 2.0 + originX, y: (viewHeight - imageSize) / 2.0, width: imageSize, height: imageSize)
            titleLabel.frame = .zero
        }
    }
}
