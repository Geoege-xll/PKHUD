//
//  PKHUD.WindowRootViewController.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/18/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// Serves as a configuration relay controller, tapping into the main window's rootViewController settings.
@MainActor
internal class WindowRootViewController: UIViewController {

    private var topViewController: UIViewController? {
        if #available(iOS 15.0, *) {
            let window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
            return window?.rootViewController
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
        }
    }

    internal override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .all
    }

    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

    internal override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }

    internal override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }

    internal override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? true
    }
}
