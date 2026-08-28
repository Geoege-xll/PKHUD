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
        checkmarkPath.move(to: CGPoint(x: 3.0, y: 22.0))
        checkmarkPath.addLine(to: CGPoint(x: 22.0, y: 42.0))
        checkmarkPath.addLine(to: CGPoint(x: 60.0, y: 0.0))

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 42.0)
        layer.path = checkmarkPath.cgPath

        layer.fillMode = .forwards
        layer.lineCap = .round
        layer.lineJoin = .round

        layer.fillColor = nil
        layer.strokeColor = PKHUD.tintColor.cgColor
        layer.lineWidth = 5.0
        return layer
    }()

    public init(title: String? = nil, subtitle: String? = nil) {
        super.init(title: title, subtitle: subtitle)
        layer.addSublayer(checkmarkShapeLayer)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(checkmarkShapeLayer)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        let hasSubtitle = !(subtitleLabel.text?.isEmpty ?? true)

        if hasTitle || hasSubtitle {
            let centerY = bounds.height * 0.40
            checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: centerY)
        } else {
            checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        checkmarkShapeLayer.strokeColor = PKHUD.tintColor.cgColor
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
