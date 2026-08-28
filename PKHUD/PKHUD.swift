//
//  PKHUD.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/13/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// The PKHUD object controls showing and hiding of the HUD, as well as its contents and touch response behavior.
@MainActor
open class PKHUD: NSObject {

    public static let sharedHUD = PKHUD()

    // MARK: - Global Configuration Properties

    /// 默认正方形 HUD 卡片尺寸（默认 110 x 110 pt）
    public static var squareSize: CGSize = CGSize(width: 110.0, height: 110.0)

    /// 默认横向宽 HUD 卡片尺寸（默认 220 x 75 pt）
    public static var wideSize: CGSize = CGSize(width: 220.0, height: 75.0)

    /// 标题字体大小（默认 15pt bold）
    public static var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 15.0)

    /// 标题字体颜色（默认 .label）
    public static var titleColor: UIColor = UIColor.label

    /// 副标题/正文字体大小（默认 13pt system）
    public static var subtitleFont: UIFont = UIFont.systemFont(ofSize: 13.0)

    /// 副标题/正文字体颜色（默认 .secondaryLabel）
    public static var subtitleColor: UIColor = UIColor.secondaryLabel

    /// 图标/加载环主题色（默认 .label）
    public static var tintColor: UIColor = UIColor.label

    // MARK: - Instance Properties

    public var viewToPresentOn: UIView?

    fileprivate let container = ContainerView()
    fileprivate var hideTimer: Timer?

    public typealias TimerAction = (Bool) -> Void
    fileprivate var timerActions = [String: TimerAction]()

    public var gracePeriod: TimeInterval = 0
    fileprivate var graceTimer: Timer?

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

    public convenience init(viewToPresentOn view: UIView) {
        self.init()
        viewToPresentOn = view
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open var dimsBackground = true
    open var userInteractionOnUnderlyingViewsEnabled: Bool {
        get {
            return !container.isUserInteractionEnabled
        }
        set {
            container.isUserInteractionEnabled = !newValue
        }
    }

    open var isVisible: Bool {
        return !container.isHidden && !container.willHide
    }

    open var cornerRadius: CGFloat {
        get {
            return container.frameView.cornerRadius
        }
        set {
            container.frameView.cornerRadius = newValue
        }
    }

    open var contentView: UIView {
        get {
            return container.frameView.content
        }
        set {
            container.frameView.content = newValue
            startAnimatingContentView()
        }
    }

    open var effect: UIVisualEffect? {
        get {
            return container.frameView.effect
        }
        set {
            container.frameView.effect = newValue
        }
    }

    open var leadingMargin: CGFloat = 0
    open var trailingMargin: CGFloat = 0

    private static func findKeyWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            return scenes.flatMap { $0.windows }.first { $0.isKeyWindow }
                ?? scenes.flatMap { $0.windows }.first
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        }
    }

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

        // If the grace time is set, postpone the HUD display
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

    open func hide(animated anim: Bool = true, completion: TimerAction? = nil) {
        graceTimer?.invalidate()

        container.hideFrameView(animated: anim, completion: completion)
        stopAnimatingContentView()
    }

    open func hide(_ animated: Bool, completion: TimerAction? = nil) {
        hide(animated: animated, completion: completion)
    }

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

    // MARK: Internal

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

    internal func registerForKeyboardNotifications() {
        container.registerForKeyboardNotifications()
    }

    internal func deregisterFromKeyboardNotifications() {
        container.deregisterFromKeyboardNotifications()
    }

    // MARK: Timer callbacks

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
