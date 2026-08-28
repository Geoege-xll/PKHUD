//
//  HUD.swift
//  PKHUD
//
//  Created by Eugene Tartakovsky on 29/01/16.
//  Copyright © 2016 Eugene Tartakovsky, NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// HUD 内容类型枚举，定义了 HUD 呈现的不同视图形态与内容数据（单提示文本极简设计）。
public enum HUDContentType: Sendable {
    /// 动画成功对勾图标（支持可选单段提示文本）
    case success(String?)
    /// 动画错误叉号图标（支持可选单段提示文本）
    case error(String?)
    /// 旋转进度菊花图标（支持可选单段提示文本）
    case progress(String?)
    /// 自定义静态图片展示（支持可选单段提示文本）
    case image(UIImage?, title: String?)
    /// 自定义自动连续旋转图片展示（支持可选单段提示文本）
    case rotatingImage(UIImage?, title: String?)

    /// 系统 SF Symbol 矢量图标（支持可选单段提示文本）
    case systemImage(name: String, title: String?)
    /// 纯文本提示卡片（最多支持 3 行文本）
    case label(String?)
    /// 系统原生大号 UIActivityIndicatorView 加载菊花
    case systemActivity(String?)
    /// 完全自定义的 UIView 内容视图
    case customView(view: UIView)

    // MARK: - 便捷静态无参属性（支持直接写 .success、.error、.progress、.image 等）

    /// 纯图标成功提示（无文本）
    public static var success: HUDContentType { return .success(nil) }
    /// 纯图标错误提示（无文本）
    public static var error: HUDContentType { return .error(nil) }
    /// 纯图标加载中提示（无文本）
    public static var progress: HUDContentType { return .progress(nil) }
    /// 系统原生加载菊花（无文本）
    public static var systemActivity: HUDContentType { return .systemActivity(nil) }

    // MARK: - 便捷静态工厂方法

    /// 自定义静态图片展示（如 `.image(img)` 或 `.image(img, "提示")`）
    public static func image(_ image: UIImage?, _ title: String? = nil) -> HUDContentType {
        return .image(image, title: title)
    }

    /// 自定义自动连续旋转图片展示（如 `.rotatingImage(img)` 或 `.rotatingImage(img, "加载中")`）
    public static func rotatingImage(_ image: UIImage?, _ title: String? = nil) -> HUDContentType {
        return .rotatingImage(image, title: title)
    }

    /// 系统 SF Symbol 矢量图标（如 `.systemImage("heart.fill", "已收藏")`）
    public static func systemImage(_ name: String, _ title: String? = nil) -> HUDContentType {
        return .systemImage(name: name, title: title)
    }
}

/// HUD 顶层便捷静态门面类，提供极简的全局配置与展示/隐藏控制接口。
@MainActor
public final class HUD {

    // MARK: - 全局外观与行为配置属性

    /// 是否对背景进行半透明遮罩变暗处理（默认为 true）
    public static var dimsBackground: Bool {
        get { return PKHUD.sharedHUD.dimsBackground }
        set { PKHUD.sharedHUD.dimsBackground = newValue }
    }

    /// 是否允许用户穿透 HUD 点击底层视图（默认为 false，即拦截底层手势交互）
    public static var allowsInteraction: Bool {
        get { return PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled }
        set { PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = newValue }
    }

    /// HUD 左侧安全边距调整
    public static var leadingMargin: CGFloat {
        get { return PKHUD.sharedHUD.leadingMargin }
        set { PKHUD.sharedHUD.leadingMargin = newValue }
    }

    /// HUD 右侧安全边距调整
    public static var trailingMargin: CGFloat {
        get { return PKHUD.sharedHUD.trailingMargin }
        set { PKHUD.sharedHUD.trailingMargin = newValue }
    }

    /// HUD 卡片圆角大小（默认 16.0 pt，启用 Apple 原生平滑曲率）
    public static var cornerRadius: CGFloat {
        get { return PKHUD.sharedHUD.cornerRadius }
        set { PKHUD.sharedHUD.cornerRadius = newValue }
    }

    /// HUD 毛玻璃视觉特效（默认 UIBlurEffect(style: .systemMaterial) 自适应深浅模式）
    public static var effect: UIVisualEffect? {
        get { return PKHUD.sharedHUD.effect }
        set { PKHUD.sharedHUD.effect = newValue }
    }

    /// 默认正方形 HUD 卡片尺寸（默认 110 x 110 pt）
    public static var squareSize: CGSize {
        get { return PKHUD.squareSize }
        set { PKHUD.squareSize = newValue }
    }

    /// 默认横向宽 HUD 卡片尺寸（默认 220 x 75 pt）
    public static var wideSize: CGSize {
        get { return PKHUD.wideSize }
        set { PKHUD.wideSize = newValue }
    }

    /// 全局提示文本字体（默认 14pt medium）
    public static var titleFont: UIFont {
        get { return PKHUD.titleFont }
        set { PKHUD.titleFont = newValue }
    }

    /// 全局提示文本颜色（默认 .label 85% alpha）
    public static var titleColor: UIColor {
        get { return PKHUD.titleColor }
        set { PKHUD.titleColor = newValue }
    }

    /// 全局图标/加载环主题色（默认 .label 85% alpha）
    public static var tintColor: UIColor {
        get { return PKHUD.tintColor }
        set { PKHUD.tintColor = newValue }
    }

    /// 当前 HUD 是否正处于显示状态
    public static var isVisible: Bool { return PKHUD.sharedHUD.isVisible }

    // MARK: - 显示与隐藏方法（基于 PKHUD 实例）

    /// 持续显示指定的 HUD 内容（不会自动消失，通常用于 Progress 耗时加载中，需手动调用 hide）
    /// - Parameters:
    ///   - content: HUD 内容类型（如 `.progress("加载中...")`）
    ///   - view: 呈现的目标视图（若为 nil，则自动挂载至当前活跃的 keyWindow）
    public static func show(_ content: HUDContentType, onView view: UIView? = nil) {
        PKHUD.sharedHUD.contentView = contentView(content)
        PKHUD.sharedHUD.show(onView: view)
    }

    /// 立即隐藏当前显示的 HUD（无淡出动画）
    /// - Parameter completion: 隐藏完成后的回调闭包
    public static func hide(_ completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(animated: false, completion: completion)
    }

    /// 隐藏当前显示的 HUD
    /// - Parameters:
    ///   - animated: 是否附带淡出动画（默认为 true）
    ///   - completion: 隐藏完成后的回调闭包
    public static func hide(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(animated: animated, completion: completion)
    }

    /// 在指定的延时时间（秒）后自动淡出隐藏 HUD
    /// - Parameters:
    ///   - delay: 延迟隐藏时间（单位：秒）
    ///   - completion: 隐藏完成后的回调闭包
    public static func hide(afterDelay delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(afterDelay: delay, completion: completion)
    }

    // MARK: - 闪现提示方法（展示并在指定时间后自动淡出消失）

    /// 闪现显示指定的 HUD 内容并在默认动画周期后自动隐藏
    /// - Parameters:
    ///   - content: HUD 内容类型（如 `.success("保存成功")`）
    ///   - view: 呈现的目标视图（若为 nil，则自动挂载至 keyWindow）
    public static func flash(_ content: HUDContentType, onView view: UIView? = nil) {
        HUD.show(content, onView: view)
        HUD.hide(animated: true, completion: nil)
    }

    /// 闪现显示指定的 HUD 内容，在指定 delay 秒后自动淡出隐藏
    /// - Parameters:
    ///   - content: HUD 内容类型（如 `.success("保存成功")`）
    ///   - view: 呈现的目标视图（若为 nil，则自动挂载至 keyWindow）
    ///   - delay: 保持展示的持续时间（秒，如 1.5 或 2.0）
    ///   - completion: 完全消失后的回调闭包
    public static func flash(_ content: HUDContentType, onView view: UIView? = nil, delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        HUD.show(content, onView: view)
        HUD.hide(afterDelay: delay, completion: completion)
    }

    // MARK: - 键盘避让监听方法

    /// 注册键盘弹出与收起监听通知（自动调整 HUD 垂直居中位置以避开键盘）
    public nonisolated static func registerForKeyboardNotifications() {
        Task { @MainActor in
            PKHUD.sharedHUD.registerForKeyboardNotifications()
        }
    }

    /// 注销键盘监听通知（可在 deinit 或页面销毁时安全调用）
    public nonisolated static func deregisterFromKeyboardNotifications() {
        Task { @MainActor in
            PKHUD.sharedHUD.deregisterFromKeyboardNotifications()
        }
    }

    // MARK: - 内部视图构建工厂

    fileprivate static func contentView(_ content: HUDContentType) -> UIView {
        switch content {
        case let .success(title):
            return PKHUDSuccessView(title: title)
        case let .error(title):
            return PKHUDErrorView(title: title)
        case let .progress(title):
            return PKHUDProgressView(title: title)
        case let .image(image, title):
            return PKHUDSquareBaseView(image: image, title: title)
        case let .rotatingImage(image, title):
            let view = PKHUDRotatingImageView(image: image, title: title)
            return view

        case let .systemImage(name, title):
            let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
            let img = UIImage(systemName: name, withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            let view = PKHUDSquareBaseView(image: img, title: title)
            view.imageView.tintColor = HUD.tintColor
            return view

        case let .label(text):
            return PKHUDTextView(text: text)
        case let .systemActivity(title):
            return PKHUDSystemActivityIndicatorView(title: title)
        case let .customView(view):
            return view
        }
    }
}
