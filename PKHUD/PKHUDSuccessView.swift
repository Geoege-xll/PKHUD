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
        checkmarkPath.move(to: CGPoint(x: 2.0, y: 16.0))
        checkmarkPath.addLine(to: CGPoint(x: 16.0, y: 30.0))
        checkmarkPath.addLine(to: CGPoint(x: 44.0, y: 0.0))

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 30.0)
        layer.path = checkmarkPath.cgPath

        layer.fillMode = .forwards
        layer.lineCap = .round
        layer.lineJoin = .round

        layer.fillColor = nil
        layer.strokeColor = PKHUD.tintColor.cgColor
        layer.lineWidth = 4.5
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

        if hasTitle && hasSubtitle {
            let centerY = bounds.height * 0.50
            checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: centerY)
        } else if hasSubtitle {
            let centerY = bounds.height * 0.36
            checkmarkShapeLayer.position = CGPoint(x: bounds.midX, y: centerY)
        } else if hasTitle {
            let centerY = bounds.height * 0.62
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
