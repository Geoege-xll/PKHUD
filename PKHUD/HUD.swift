//
//  HUD.swift
//  PKHUD
//
//  Created by Eugene Tartakovsky on 29/01/16.
//  Copyright © 2016 Eugene Tartakovsky, NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// HUD 内容类型枚举，定义了 HUD 呈现的不同视图形态与内容数据。
public enum HUDContentType: Sendable {
    /// 动画成功对勾图标（无文本）
    case success
    /// 动画错误叉号图标（无文本）
    case error
    /// 旋转进度菊花图标（无文本）
    case progress
    /// 自定义静态图片展示（无文本）
    case image(UIImage?)
    /// 自定义自动连续旋转图片展示（无文本）
    case rotatingImage(UIImage?)

    /// 带有主标题与副标题的动画成功对勾
    case labeledSuccess(title: String?, subtitle: String?)
    /// 带有主标题与副标题的动画错误叉号
    case labeledError(title: String?, subtitle: String?)
    /// 带有主标题与副标题的旋转进度菊花
    case labeledProgress(title: String?, subtitle: String?)
    /// 带有主标题与副标题的自定义静态图片
    case labeledImage(image: UIImage?, title: String?, subtitle: String?)
    /// 带有主标题与副标题的自定义旋转图片
    case labeledRotatingImage(image: UIImage?, title: String?, subtitle: String?)

    /// 系统 SF Symbol 矢量图标（支持主/副标题，可自适应深浅模式及主题色）
    case systemImage(name: String, title: String?, subtitle: String?)
    /// 纯文本提示卡片（最多支持 3 行文本）
    case label(String?)
    /// 系统原生大号 UIActivityIndicatorView 加载菊花
    case systemActivity
    /// 完全自定义的 UIView 内容视图
    case customView(view: UIView)

    // MARK: - 便捷静态工厂构造方法（支持默认参数为 nil，极简调用）

    /// 成功提示（快捷仅传副标题，如 `.success(subtitle: "保存成功")`）
    /// - Parameter subtitle: 提示副标题文本
    /// - Returns: HUDContentType 实例
    public static func success(subtitle: String) -> HUDContentType {
        return .labeledSuccess(title: nil, subtitle: subtitle)
    }

    /// 成功提示（传主标题与可选副标题，如 `.success(title: "成功", subtitle: "支付已完成")`）
    /// - Parameters:
    ///   - title: 提示主标题文本
    ///   - subtitle: 提示副标题文本（默认为 nil）
    /// - Returns: HUDContentType 实例
    public static func success(title: String, subtitle: String? = nil) -> HUDContentType {
        return .labeledSuccess(title: title, subtitle: subtitle)
    }

    /// 错误提示（快捷仅传副标题，如 `.error(subtitle: "网络连接失败")`）
    /// - Parameter subtitle: 错误描述副标题文本
    /// - Returns: HUDContentType 实例
    public static func error(subtitle: String) -> HUDContentType {
        return .labeledError(title: nil, subtitle: subtitle)
    }

    /// 错误提示（传主标题与可选副标题，如 `.error(title: "加载失败", subtitle: "请检查网络设置")`）
    /// - Parameters:
    ///   - title: 错误主标题文本
    ///   - subtitle: 错误副标题文本（默认为 nil）
    /// - Returns: HUDContentType 实例
    public static func error(title: String, subtitle: String? = nil) -> HUDContentType {
        return .labeledError(title: title, subtitle: subtitle)
    }

    /// 加载中进度提示（快捷仅传副标题，如 `.progress(subtitle: "加载中...")`）
    /// - Parameter subtitle: 描述副标题文本
    /// - Returns: HUDContentType 实例
    public static func progress(subtitle: String) -> HUDContentType {
        return .labeledProgress(title: nil, subtitle: subtitle)
    }

    /// 加载中进度提示（传主标题与可选副标题，如 `.progress(title: "请稍候", subtitle: "正在同步数据...")`）
    /// - Parameters:
    ///   - title: 主标题文本
    ///   - subtitle: 描述副标题文本（默认为 nil）
    /// - Returns: HUDContentType 实例
    public static func progress(title: String, subtitle: String? = nil) -> HUDContentType {
        return .labeledProgress(title: title, subtitle: subtitle)
    }

    /// 系统 SF Symbol 矢量图标（如 `.systemImage("heart.fill", subtitle: "已收藏")`）
    /// - Parameters:
    ///   - name: SF Symbol 图标名称（如 "checkmark", "xmark", "info.circle", "star.fill" 等）
    ///   - title: 可选主标题文本（默认为 nil）
    ///   - subtitle: 可选副标题文本（默认为 nil）
    /// - Returns: HUDContentType 实例
    public static func systemImage(_ name: String, title: String? = nil, subtitle: String? = nil) -> HUDContentType {
        return .systemImage(name: name, title: title, subtitle: subtitle)
    }

    /// 自定义静态图片提示
    /// - Parameters:
    ///   - image: 自定义图片
    ///   - title: 可选主标题文本（默认为 nil）
    ///   - subtitle: 可选副标题文本（默认为 nil）
    /// - Returns: HUDContentType 实例
    public static func image(_ image: UIImage?, title: String? = nil, subtitle: String? = nil) -> HUDContentType {
        return .labeledImage(image: image, title: title, subtitle: subtitle)
    }

    /// 自定义持续旋转图片提示（适用于自定义 Loading 动画）
    /// - Parameters:
    ///   - image: 自定义旋转图片
    ///   - title: 可选主标题文本（默认为 nil）
    ///   - subtitle: 可选副标题文本（默认为 nil）
    /// - Returns: HUDContentType 实例
    public static func rotatingImage(_ image: UIImage?, title: String? = nil, subtitle: String? = nil) -> HUDContentType {
        return .labeledRotatingImage(image: image, title: title, subtitle: subtitle)
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

    /// 全局主标题字体（默认 15pt bold）
    public static var titleFont: UIFont {
        get { return PKHUD.titleFont }
        set { PKHUD.titleFont = newValue }
    }

    /// 全局主标题颜色（默认 .label 自适应深浅模式）
    public static var titleColor: UIColor {
        get { return PKHUD.titleColor }
        set { PKHUD.titleColor = newValue }
    }

    /// 全局副标题字体（默认 13pt system）
    public static var subtitleFont: UIFont {
        get { return PKHUD.subtitleFont }
        set { PKHUD.subtitleFont = newValue }
    }

    /// 全局副标题颜色（默认 .secondaryLabel 自适应深浅模式）
    public static var subtitleColor: UIColor {
        get { return PKHUD.subtitleColor }
        set { PKHUD.subtitleColor = newValue }
    }

    /// 全局图标/加载环主题色（默认 .label 自适应深浅模式）
    public static var tintColor: UIColor {
        get { return PKHUD.tintColor }
        set { PKHUD.tintColor = newValue }
    }

    /// 当前 HUD 是否正处于显示状态
    public static var isVisible: Bool { return PKHUD.sharedHUD.isVisible }

    // MARK: - 显示与隐藏方法（基于 PKHUD 实例）

    /// 持续显示指定的 HUD 内容（不会自动消失，通常用于 Progress 耗时加载中，需手动调用 hide）
    /// - Parameters:
    ///   - content: HUD 内容类型（如 `.progress(subtitle: "加载中...")`）
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
    ///   - content: HUD 内容类型（如 `.success(subtitle: "保存成功")`）
    ///   - view: 呈现的目标视图（若为 nil，则自动挂载至 keyWindow）
    public static func flash(_ content: HUDContentType, onView view: UIView? = nil) {
        HUD.show(content, onView: view)
        HUD.hide(animated: true, completion: nil)
    }

    /// 闪现显示指定的 HUD 内容，在指定 delay 秒后自动淡出隐藏
    /// - Parameters:
    ///   - content: HUD 内容类型（如 `.success(subtitle: "保存成功")`）
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
        case .success:
            return PKHUDSuccessView()
        case .error:
            return PKHUDErrorView()
        case .progress:
            return PKHUDProgressView()
        case let .image(image):
            return PKHUDSquareBaseView(image: image)
        case let .rotatingImage(image):
            return PKHUDRotatingImageView(image: image)

        case let .labeledSuccess(title, subtitle):
            return PKHUDSuccessView(title: title, subtitle: subtitle)
        case let .labeledError(title, subtitle):
            return PKHUDErrorView(title: title, subtitle: subtitle)
        case let .labeledProgress(title, subtitle):
            return PKHUDProgressView(title: title, subtitle: subtitle)
        case let .labeledImage(image, title, subtitle):
            return PKHUDSquareBaseView(image: image, title: title, subtitle: subtitle)
        case let .labeledRotatingImage(image, title, subtitle):
            return PKHUDRotatingImageView(image: image, title: title, subtitle: subtitle)

        case let .systemImage(name, title, subtitle):
            let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
            let img = UIImage(systemName: name, withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            let view = PKHUDSquareBaseView(image: img, title: title, subtitle: subtitle)
            view.imageView.tintColor = HUD.tintColor
            return view

        case let .label(text):
            return PKHUDTextView(text: text)
        case .systemActivity:
            return PKHUDSystemActivityIndicatorView()
        case let .customView(view):
            return view
        }
    }
}
