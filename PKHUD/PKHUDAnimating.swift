//
//  PKHUDAnimatingContentView.swift
//  PKHUD
//
//  Created by Philip Kluz on 9/27/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDAnimating 动画视图协议，遵循此协议的视图在 HUD 显示与隐藏时会自动触发启动和停止动画。
@MainActor
@objc public protocol PKHUDAnimating {
    /// 触发并启动动画
    func startAnimation()
    /// 停止动画
    @objc optional func stopAnimation()
}
