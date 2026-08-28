//
//  PKHUDSystemActivityIndicatorView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSystemActivityIndicatorView provides the system UIActivityIndicatorView as an alternative.
@MainActor
public final class PKHUDSystemActivityIndicatorView: PKHUDSquareBaseView, PKHUDAnimating {

    public init() {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = UIColor.clear
        alpha = 0.95

        addSubview(activityIndicatorView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        let hasSubtitle = !(subtitleLabel.text?.isEmpty ?? true)

        if hasTitle && hasSubtitle {
            activityIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.height * 0.50)
        } else if hasSubtitle {
            activityIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.height * 0.36)
        } else if hasTitle {
            activityIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.height * 0.62)
        } else {
            activityIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }

    let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = PKHUD.tintColor
        return activity
    }()

    public func startAnimation() {
        activityIndicatorView.startAnimating()
    }

    public func stopAnimation() {
        activityIndicatorView.stopAnimating()
    }
}
