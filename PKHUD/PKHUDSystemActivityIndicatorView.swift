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
    public init() {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        commonInit()
    }

    /// 使用指定 Frame 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    /// 解档初始化
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = UIColor.clear
        alpha = 0.95

        addSubview(activityIndicatorView)
    }

    /// 布局指示器中心点（始终锁定在卡片几何正中心）
    public override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
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
