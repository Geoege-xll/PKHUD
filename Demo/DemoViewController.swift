//
//  DemoViewController.swift
//  PKHUD Demo
//
//  Created by Philip Kluz on 6/18/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//

import UIKit
import PKHUD

class DemoViewController: UIViewController {

    let hiddenTextField = UITextField(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(hiddenTextField)
        HUD.registerForKeyboardNotifications()

        HUD.dimsBackground = false
        HUD.allowsInteraction = false
    }

    @IBAction func showHideKeyboard(_ sender: Any) {
        if hiddenTextField.isEditing {
            view.endEditing(true)
        } else {
            hiddenTextField.becomeFirstResponder()
        }
    }

    @IBAction func showAnimatedSuccessHUD(_ sender: AnyObject) {
        HUD.flash(.success("保存成功"), delay: 2.0)
    }

    @IBAction func showAnimatedErrorHUD(_ sender: AnyObject) {
        HUD.flash(.error("网络连接失败"), delay: 2.0)
    }

    @IBAction func showAnimatedProgressHUD(_ sender: AnyObject) {
        HUD.show(.progress)

        // 模拟异步任务
        delay(2.0) {
            HUD.flash(.success("完成"), delay: 1.0)
        }
    }

    @IBAction func showCustomProgressHUD(_ sender: AnyObject) {
        HUD.flash(.rotatingImage(UIImage(named: "progress"), "正在处理"), delay: 2.0)
    }

    @IBAction func showAnimatedStatusProgressHUD(_ sender: AnyObject) {
        HUD.flash(.progress("加载中..."), delay: 2.0)
    }

    @IBAction func showTextHUD(_ sender: AnyObject) {
        HUD.flash(.label("请先同意用户服务协议"), delay: 2.0) { _ in
            print("License Obtained.")
        }
    }

    deinit {
        HUD.deregisterFromKeyboardNotifications()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}
