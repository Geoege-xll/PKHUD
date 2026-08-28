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
        dash.frame = CGRect(x: 0.0, y: 0.0, width: 38.0, height: 38.0)
        dash.path = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: 19.0))
            path.addLine(to: CGPoint(x: 38.0, y: 19.0))
            return path.cgPath
        }()

        dash.lineCap = .round
        dash.lineJoin = .round
        dash.fillMode = .forwards

        dash.fillColor = nil
        dash.strokeColor = PKHUD.tintColor.cgColor
        dash.lineWidth = 4.5
        return dash
    }

    public init(title: String? = nil, subtitle: String? = nil) {
        super.init(title: title, subtitle: subtitle)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        let hasSubtitle = !(subtitleLabel.text?.isEmpty ?? true)

        let center: CGPoint
        if hasTitle && hasSubtitle {
            center = CGPoint(x: bounds.midX, y: bounds.height * 0.50)
        } else if hasSubtitle {
            center = CGPoint(x: bounds.midX, y: bounds.height * 0.36)
        } else if hasTitle {
            center = CGPoint(x: bounds.midX, y: bounds.height * 0.62)
        } else {
            center = CGPoint(x: bounds.midX, y: bounds.midY)
        }

        dashOneLayer.position = center
        dashTwoLayer.position = center
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        dashOneLayer.strokeColor = PKHUD.tintColor.cgColor
        dashTwoLayer.strokeColor = PKHUD.tintColor.cgColor
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
