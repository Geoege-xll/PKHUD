//
//  PKHUDWideBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDWideBaseView 横向宽卡片基础视图，可作为长文本或宽版提示的基础容器进行继承与拓展。
@MainActor
open class PKHUDWideBaseView: UIView {

    /// 默认横向宽基础视图 Frame
    public static var defaultWideBaseViewFrame: CGRect {
        return CGRect(origin: .zero, size: PKHUD.wideSize)
    }

    /// 初始化宽卡片视图
    public init() {
        super.init(frame: PKHUDWideBaseView.defaultWideBaseViewFrame)
    }

    /// 使用指定 Frame 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
