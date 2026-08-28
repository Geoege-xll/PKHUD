//
//  HUD.swift
//  PKHUD
//
//  Created by Eugene Tartakovsky on 29/01/16.
//  Copyright © 2016 Eugene Tartakovsky, NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

public enum HUDContentType: Sendable {
    case success
    case error
    case progress
    case image(UIImage?)
    case rotatingImage(UIImage?)

    case labeledSuccess(title: String?, subtitle: String?)
    case labeledError(title: String?, subtitle: String?)
    case labeledProgress(title: String?, subtitle: String?)
    case labeledImage(image: UIImage?, title: String?, subtitle: String?)
    case labeledRotatingImage(image: UIImage?, title: String?, subtitle: String?)

    case systemImage(name: String, title: String?, subtitle: String?)
    case label(String?)
    case systemActivity
    case customView(view: UIView)
}

@MainActor
public final class HUD {

    // MARK: Properties
    public static var dimsBackground: Bool {
        get { return PKHUD.sharedHUD.dimsBackground }
        set { PKHUD.sharedHUD.dimsBackground = newValue }
    }

    public static var allowsInteraction: Bool {
        get { return PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled }
        set { PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = newValue }
    }

    public static var leadingMargin: CGFloat {
        get { return PKHUD.sharedHUD.leadingMargin }
        set { PKHUD.sharedHUD.leadingMargin = newValue }
    }

    public static var trailingMargin: CGFloat {
        get { return PKHUD.sharedHUD.trailingMargin }
        set { PKHUD.sharedHUD.trailingMargin = newValue }
    }

    public static var cornerRadius: CGFloat {
        get { return PKHUD.sharedHUD.cornerRadius }
        set { PKHUD.sharedHUD.cornerRadius = newValue }
    }

    public static var effect: UIVisualEffect? {
        get { return PKHUD.sharedHUD.effect }
        set { PKHUD.sharedHUD.effect = newValue }
    }

    public static var squareSize: CGSize {
        get { return PKHUD.squareSize }
        set { PKHUD.squareSize = newValue }
    }

    public static var wideSize: CGSize {
        get { return PKHUD.wideSize }
        set { PKHUD.wideSize = newValue }
    }

    public static var titleFont: UIFont {
        get { return PKHUD.titleFont }
        set { PKHUD.titleFont = newValue }
    }

    public static var titleColor: UIColor {
        get { return PKHUD.titleColor }
        set { PKHUD.titleColor = newValue }
    }

    public static var subtitleFont: UIFont {
        get { return PKHUD.subtitleFont }
        set { PKHUD.subtitleFont = newValue }
    }

    public static var subtitleColor: UIColor {
        get { return PKHUD.subtitleColor }
        set { PKHUD.subtitleColor = newValue }
    }

    public static var tintColor: UIColor {
        get { return PKHUD.tintColor }
        set { PKHUD.tintColor = newValue }
    }

    public static var isVisible: Bool { return PKHUD.sharedHUD.isVisible }

    // MARK: Public methods, PKHUD based
    public static func show(_ content: HUDContentType, onView view: UIView? = nil) {
        PKHUD.sharedHUD.contentView = contentView(content)
        PKHUD.sharedHUD.show(onView: view)
    }

    public static func hide(_ completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(animated: false, completion: completion)
    }

    public static func hide(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(animated: animated, completion: completion)
    }

    public static func hide(afterDelay delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(afterDelay: delay, completion: completion)
    }

    // MARK: Public methods, HUD based
    public static func flash(_ content: HUDContentType, onView view: UIView? = nil) {
        HUD.show(content, onView: view)
        HUD.hide(animated: true, completion: nil)
    }

    public static func flash(_ content: HUDContentType, onView view: UIView? = nil, delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        HUD.show(content, onView: view)
        HUD.hide(afterDelay: delay, completion: completion)
    }

    // MARK: Keyboard Methods
    public nonisolated static func registerForKeyboardNotifications() {
        Task { @MainActor in
            PKHUD.sharedHUD.registerForKeyboardNotifications()
        }
    }

    public nonisolated static func deregisterFromKeyboardNotifications() {
        Task { @MainActor in
            PKHUD.sharedHUD.deregisterFromKeyboardNotifications()
        }
    }

    // MARK: Private methods
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
            let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .semibold)
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
