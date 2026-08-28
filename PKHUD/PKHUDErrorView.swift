//
//  PKHUDErrorAnimation.swift
//  PKHUD
//
//  Created by Philip Kluz on 9/27/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDErrorView provides an animated error (cross) view.
@MainActor
open class PKHUDErrorView: PKHUDSquareBaseView, PKHUDAnimating {

    var dashOneLayer = PKHUDErrorView.generateDashLayer()
    var dashTwoLayer = PKHUDErrorView.generateDashLayer()

    class func generateDashLayer() -> CAShapeLayer {
        let dash = CAShapeLayer()
        dash.frame = CGRect(x: 0.0, y: 0.0, width: 88.0, height: 88.0)
        dash.path = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: 44.0))
            path.addLine(to: CGPoint(x: 88.0, y: 44.0))
            return path.cgPath
        }()

        dash.lineCap = .round
        dash.lineJoin = .round
        dash.fillMode = .forwards

        dash.fillColor = nil
        dash.strokeColor = UIColor.label.cgColor
        dash.lineWidth = 6
        return dash
    }

    public init(title: String? = nil, subtitle: String? = nil) {
        super.init(title: title, subtitle: subtitle)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
        dashOneLayer.position = layer.position
        dashTwoLayer.position = layer.position
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
        dashOneLayer.position = layer.position
        dashTwoLayer.position = layer.position
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        dashOneLayer.strokeColor = UIColor.label.cgColor
        dashTwoLayer.strokeColor = UIColor.label.cgColor
    }

    func rotationAnimation(_ angle: CGFloat) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let values: [NSNumber] = [0.0, NSNumber(value: Float(angle * (.pi / 180)))]
        animation.values = values
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }

    func scaleAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        let values: [NSNumber] = [1.0, 1.2, 1.0]
        animation.values = values
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }

    open func startAnimation() {
        let dashOneAnimation = rotationAnimation(45.0)
        let dashTwoAnimation = rotationAnimation(-45.0)

        dashOneLayer.transform = CATransform3DMakeRotation(45.0 * (.pi / 180), 0.0, 0.0, 1.0)
        dashTwoLayer.transform = CATransform3DMakeRotation(-45.0 * (.pi / 180), 0.0, 0.0, 1.0)

        dashOneLayer.add(dashOneAnimation, forKey: "dashOneAnimation")
        dashTwoLayer.add(dashTwoAnimation, forKey: "dashTwoAnimation")
    }

    open func stopAnimation() {
        dashOneLayer.removeAnimation(forKey: "dashOneAnimation")
        dashTwoLayer.removeAnimation(forKey: "dashTwoAnimation")
    }
}
