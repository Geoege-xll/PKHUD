//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView HUD 基础容器视图，参考 ProgressHUD / SVProgressHUD 现代设计规范，支持内容自适应动态尺寸与精准黄金留白。
@MainActor
open class PKHUDSquareBaseView: UIView {

    /// 默认基础视图 Frame
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

    /// 便捷初始化 HUD 视图
    /// - Parameters:
    ///   - image: 展示的静态/矢量图标
    ///   - title: 可选提示文本
    public init(image: UIImage? = nil, title: String? = nil) {
        super.init(frame: .zero)
        self.imageView.image = image
        titleLabel.text = title

        addSubview(imageView)
        addSubview(titleLabel)

        updateDynamicFrame()
    }

    /// 居中图标视图
    public let imageView: UIImageView = {
        let imageView = UIImageView()
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
        label.minimumScaleFactor = 0.3
        return label
    }()

    /// 参考 ProgressHUD 计算自适应动态卡片尺寸（消除冗余大边框与空隙，使整体紧凑精致）
    open func updateDynamicFrame() {
        let hasText = !(titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

        if hasText, let text = titleLabel.text {
            let font = PKHUD.titleFont
            let maxTextWidth: CGFloat = 200.0
            let boundingSize = CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude)
            let textRect = (text as NSString).boundingRect(
                with: boundingSize,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font],
                context: nil
            )
            let textWidth = ceil(textRect.width)
            let textHeight = max(18.0, ceil(textRect.height))

            let hPadding: CGFloat = 18.0
            let vPadding: CGFloat = 16.0
            let iconSize: CGFloat = 32.0
            let spacing: CGFloat = 10.0

            let calculatedWidth = max(108.0, min(240.0, textWidth + 2 * hPadding))
            let calculatedHeight = vPadding + iconSize + spacing + textHeight + vPadding

            frame = CGRect(origin: .zero, size: CGSize(width: calculatedWidth, height: calculatedHeight))
        } else {
            // 纯图标模式：紧凑精致的 92 × 92 pt 正方形
            frame = CGRect(origin: .zero, size: CGSize(width: 92.0, height: 92.0))
        }
    }

    /// 重新布局子视图
    open override func layoutSubviews() {
        super.layoutSubviews()

        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height
        let hasTitle = !(titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)

        if hasTitle {
            let hPadding: CGFloat = 14.0
            let vPadding: CGFloat = 16.0
            let iconSize: CGFloat = 32.0
            let spacing: CGFloat = 10.0
            let textWidth = max(0, viewWidth - 2 * hPadding)
            let textHeight = max(18.0, viewHeight - vPadding * 2 - iconSize - spacing)

            imageView.frame = CGRect(
                x: (viewWidth - iconSize) / 2.0,
                y: vPadding,
                width: iconSize,
                height: iconSize
            )

            titleLabel.frame = CGRect(
                x: hPadding,
                y: vPadding + iconSize + spacing,
                width: textWidth,
                height: textHeight
            )
        } else {
            let iconSize: CGFloat = 38.0
            imageView.frame = CGRect(
                x: (viewWidth - iconSize) / 2.0,
                y: (viewHeight - iconSize) / 2.0,
                width: iconSize,
                height: iconSize
            )
            titleLabel.frame = .zero
        }
    }
}
