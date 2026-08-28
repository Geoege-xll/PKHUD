//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView 正方形 HUD 基础容器视图，遵循 PKHUD 原作者经典的 1:2:1 三段式黄金比例排版设计。
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
    ///   - title: 可选主标题
    ///   - subtitle: 可选副标题
    public init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        self.imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
        commonInit()
    }

    private func commonInit() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    /// 居中图标视图（位于卡片中间 50% 区域，居中显示）
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.85
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.tintColor = PKHUD.tintColor
        return imageView
    }()

    /// 主标题标签（位于顶部 25% 区域）
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PKHUD.titleFont
        label.textColor = PKHUD.titleColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    /// 副标题标签（位于底部 25% 区域）
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

    /// 重新布局子视图：恢复原作者纯正的 1/4 (标题) : 2/4 (图标居中) : 1/4 (副标题) 经典三段式比例排版
    open override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = PKHUD.sharedHUD.leadingMargin + PKHUD.sharedHUD.trailingMargin
        let originX: CGFloat = margin > 0 ? margin : 0.0
        let viewWidth = bounds.size.width - 2 * margin
        let viewHeight = bounds.size.height

        let halfHeight = CGFloat(ceilf(CFloat(viewHeight / 2.0)))
        let quarterHeight = CGFloat(ceilf(CFloat(viewHeight / 4.0)))
        let threeQuarterHeight = CGFloat(ceilf(CFloat(viewHeight / 4.0 * 3.0)))

        titleLabel.frame = CGRect(origin: CGPoint(x: originX, y: 0.0), size: CGSize(width: viewWidth, height: quarterHeight))
        imageView.frame = CGRect(origin: CGPoint(x: originX, y: quarterHeight), size: CGSize(width: viewWidth, height: halfHeight))
        subtitleLabel.frame = CGRect(origin: CGPoint(x: originX, y: threeQuarterHeight), size: CGSize(width: viewWidth, height: quarterHeight))
    }
}
