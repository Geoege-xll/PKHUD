//
//  PKHUDCheckmarkView.swift
//  PKHUD
//
//  Created by Philip Kluz on 9/27/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSuccessView provides an animated success (checkmark) view.
@MainActor
open class PKHUDSuccessView: PKHUDSquareBaseView, PKHUDAnimating {

    var checkmarkShapeLayer: CAShapeLayer = {
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: 4.0, y: 27.0))
        checkmarkPath.addLine(to: CGPoint(x: 34.0, y: 56.0))
        checkmarkPath.addLine(to: CGPoint(x: 88.0, y: 0.0))

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 3.0, y: 3.0, width: 88.0, height: 56.0)
        layer.path = checkmarkPath.cgPath

        layer.fillMode = .forwards
        layer.lineCap = .round
        layer.lineJoin = .round

        layer.fillColor = nil
        layer.strokeColor = UIColor.label.cgColor
        layer.lineWidth = 6.0
        return layer
    }()

    public init(title: String? = nil, subtitle: String? = nil) {
        super.init(title: title, subtitle: subtitle)
        layer.addSublayer(checkmarkShapeLayer)
        checkmarkShapeLayer.position = layer.position
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(checkmarkShapeLayer)
        checkmarkShapeLayer.position = layer.position
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        checkmarkShapeLayer.strokeColor = UIColor.label.cgColor
    }

    open func startAnimation() {
        let checkmarkStrokeAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        checkmarkStrokeAnimation.values = [0, 1]
        checkmarkStrokeAnimation.keyTimes = [0, 1]
        checkmarkStrokeAnimation.duration = 0.35

        checkmarkShapeLayer.add(checkmarkStrokeAnimation, forKey: "checkmarkStrokeAnim")
    }

    open func stopAnimation() {
        checkmarkShapeLayer.removeAnimation(forKey: "checkmarkStrokeAnimation")
    }
}
