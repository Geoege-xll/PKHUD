//
//  PKHUD.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/13/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUD 核心控制器类，负责 HUD 窗口的管理、呈现/隐藏调度、动画生命周期以及触控事件拦截。
@MainActor
open class PKHUD: NSObject {

    /// PKHUD 单例对象
    public static let sharedHUD = PKHUD()

    // MARK: - 全局默认外观与排版配置

    /// 默认正方形 HUD 卡片尺寸（默认 110 x 110 pt）
    public static var squareSize: CGSize = CGSize(width: 110.0, height: 110.0)

    /// 默认横向宽 HUD 卡片尺寸（默认 220 x 75 pt）
    public static var wideSize: CGSize = CGSize(width: 220.0, height: 75.0)

    /// 默认主标题字体（默认 15pt bold）
    public static var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 15.0)

    /// 默认主标题颜色（默认 .label）
    public static var titleColor: UIColor = UIColor.label

    /// 默认副标题字体（默认 13pt system）
    public static var subtitleFont: UIFont = UIFont.systemFont(ofSize: 13.0)

    /// 默认副标题颜色（默认 .secondaryLabel）
    public static var subtitleColor: UIColor = UIColor.secondaryLabel

    /// 默认图标/动效主题色（默认 .label）
    public static var tintColor: UIColor = UIColor.label

    // MARK: - 实例属性

    /// 指定展示的目标视图容器（为 nil 时自动寻找当前活跃的 keyWindow）
    public var viewToPresentOn: UIView?

    fileprivate let container = ContainerView()
    fileprivate var hideTimer: Timer?

    /// 隐藏动画完成回调类型
    public typealias TimerAction = (Bool) -> Void
    fileprivate var timerActions = [String: TimerAction]()

    /// 延时宽限期（单位：秒）。在此宽限期内如果任务完成并调用了 hide，HUD 将不会显示，避免闪烁。默认 0。
    public var gracePeriod: TimeInterval = 0
    fileprivate var graceTimer: Timer?

    /// 初始化 PKHUD 实例
    public override init() {
        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PKHUD.willEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        userInteractionOnUnderlyingViewsEnabled = false
        container.frameView.autoresizingMask = [ .flexibleLeftMargin,
                                                 .flexibleRightMargin,
                                                 .flexibleTopMargin,
                                                 .flexibleBottomMargin ]

        self.container.isAccessibilityElement = true
        self.container.accessibilityIdentifier = "PKHUD"
    }

    /// 便利构造方法，指定展示的父视图
    /// - Parameter view: 承载 HUD 的视图
    public convenience init(viewToPresentOn view: UIView) {
        self.init()
        viewToPresentOn = view
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// 是否对背景进行半透明变暗遮罩（默认 true）
    open var dimsBackground = true

    /// 是否允许用户穿透 HUD 点击底层视图（默认 false）
    open var userInteractionOnUnderlyingViewsEnabled: Bool {
        get {
            return !container.isUserInteractionEnabled
        }
        set {
            container.isUserInteractionEnabled = !newValue
        }
    }

    /// 当前 HUD 是否可见
    open var isVisible: Bool {
        return !container.isHidden && !container.willHide
    }

    /// HUD 毛玻璃卡片圆角大小（默认 16.0 pt，启用 Apple 原生平滑曲率）
    open var cornerRadius: CGFloat {
        get {
            return container.frameView.cornerRadius
        }
        set {
            container.frameView.cornerRadius = newValue
        }
    }

    /// HUD 内部承载的内容视图
    open var contentView: UIView {
        get {
            return container.frameView.content
        }
        set {
            container.frameView.content = newValue
            startAnimatingContentView()
        }
    }

    /// HUD 毛玻璃视觉特效
    open var effect: UIVisualEffect? {
        get {
            return container.frameView.effect
        }
        set {
            container.frameView.effect = newValue
        }
    }

    /// HUD 容器左侧安全边距
    open var leadingMargin: CGFloat = 0

    /// HUD 容器右侧安全边距
    open var trailingMargin: CGFloat = 0

    // MARK: - 辅助方法

    private static func findKeyWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            return scenes.flatMap { $0.windows }.first { $0.isKeyWindow }
                ?? scenes.flatMap { $0.windows }.first
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        }
    }

    // MARK: - 公开展现与隐藏控制方法

    /// 显示 HUD
    /// - Parameter view: 指定挂载的父视图（为 nil 时自动获取 keyWindow）
    open func show(onView view: UIView? = nil) {
        guard let targetView = view ?? viewToPresentOn ?? PKHUD.findKeyWindow() else {
            return
        }

        if !targetView.subviews.contains(container) {
            targetView.addSubview(container)
            container.frame.origin = CGPoint.zero
            container.frame.size = targetView.frame.size
            container.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            container.isHidden = true
        }

        if dimsBackground {
            container.showBackground(animated: true)
        }

        // 如果设置了宽限期，延迟展现
        if gracePeriod > 0.0 {
            let timer = Timer(timeInterval: gracePeriod, target: self, selector: #selector(PKHUD.handleGraceTimer(_:)), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: .common)
            graceTimer = timer
        } else {
            showContent()
        }
    }

    func showContent() {
        graceTimer?.invalidate()
        container.showFrameView()
        startAnimatingContentView()
    }

    /// 隐藏 HUD
    /// - Parameters:
    ///   - anim: 是否包含淡出动画（默认 true）
    ///   - completion: 隐藏完成回调
    open func hide(animated anim: Bool = true, completion: TimerAction? = nil) {
        graceTimer?.invalidate()

        container.hideFrameView(animated: anim, completion: completion)
        stopAnimatingContentView()
    }

    /// 隐藏 HUD（包含动画）
    /// - Parameters:
    ///   - animated: 是否包含动画
    ///   - completion: 隐藏完成回调
    open func hide(_ animated: Bool, completion: TimerAction? = nil) {
        hide(animated: animated, completion: completion)
    }

    /// 在指定的 delay 秒后自动淡出隐藏 HUD
    /// - Parameters:
    ///   - delay: 延迟秒数
    ///   - completion: 隐藏完成回调
    open func hide(afterDelay delay: TimeInterval, completion: TimerAction? = nil) {
        let key = UUID().uuidString
        let userInfo = ["timerActionKey": key]
        if let completion = completion {
            timerActions[key] = completion
        }

        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(timeInterval: delay,
                                         target: self,
                                         selector: #selector(PKHUD.performDelayedHide(_:)),
                                         userInfo: userInfo,
                                         repeats: false)
    }

    // MARK: - 内部通知与动效控制

    @objc internal func willEnterForeground(_ notification: Notification?) {
        self.startAnimatingContentView()
    }

    internal func startAnimatingContentView() {
        if let animatingContentView = contentView as? PKHUDAnimating, isVisible {
            animatingContentView.startAnimation()
        }
    }

    internal func stopAnimatingContentView() {
        if let animatingContentView = contentView as? PKHUDAnimating {
            animatingContentView.stopAnimation?()
        }
    }

    /// 注册键盘监听
    internal func registerForKeyboardNotifications() {
        container.registerForKeyboardNotifications()
    }

    /// 注销键盘监听
    internal func deregisterFromKeyboardNotifications() {
        container.deregisterFromKeyboardNotifications()
    }

    // MARK: - 定时器回调

    @objc internal func performDelayedHide(_ timer: Timer? = nil) {
        let userInfo = timer?.userInfo as? [String: AnyObject]
        let key = userInfo?["timerActionKey"] as? String
        var completion: TimerAction?

        if let key = key, let action = timerActions[key] {
            completion = action
            timerActions[key] = nil
        }

        hide(animated: true, completion: completion)
    }

    @objc internal func handleGraceTimer(_ timer: Timer? = nil) {
        if graceTimer?.isValid == true {
            showContent()
        }
    }
}
