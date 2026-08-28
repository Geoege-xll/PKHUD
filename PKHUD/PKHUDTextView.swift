//
//  PKHUDTextView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDTextView 提供支持最多三行文本展示的横向宽卡片视图（适合纯文字 Toast 提示）。
@MainActor
open class PKHUDTextView: PKHUDWideBaseView {

    /// 使用文本初始化视图
    /// - Parameter text: 提示文本内容
    public init(text: String?) {
        super.init()
        commonInit(text)
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit("")
    }

    func commonInit(_ text: String?) {
        titleLabel.text = text
        addSubview(titleLabel)
    }

    /// 布局子视图
    open override func layoutSubviews() {
        super.layoutSubviews()

        let padding: CGFloat = 12.0
        titleLabel.frame = bounds.insetBy(dx: padding, dy: padding)
    }

    /// 提示文本标签
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PKHUD.titleFont
        label.textColor = PKHUD.titleColor
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 3
        return label
    }()
}
