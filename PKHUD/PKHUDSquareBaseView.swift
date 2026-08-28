//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView provides a square view, which you can subclass and add additional views to.
@MainActor
open class PKHUDSquareBaseView: UIView {

    public static var defaultSquareBaseViewFrame: CGRect {
        return CGRect(origin: .zero, size: PKHUD.squareSize)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        self.imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.tintColor = PKHUD.tintColor
        return imageView
    }()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PKHUD.titleFont
        label.textColor = PKHUD.titleColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PKHUD.subtitleFont
        label.textColor = PKHUD.subtitleColor
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.25
        return label
    }()

    open override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = PKHUD.sharedHUD.leadingMargin + PKHUD.sharedHUD.trailingMargin
        let originX: CGFloat = margin > 0 ? margin : 0.0
        let viewWidth = bounds.size.width - 2 * margin
        let viewHeight = bounds.size.height

        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        let hasSubtitle = !(subtitleLabel.text?.isEmpty ?? true)

        if hasTitle && hasSubtitle {
            let labelHeight: CGFloat = ceil(viewHeight * 0.22)
            let imageHeight: CGFloat = viewHeight - 2 * labelHeight
            titleLabel.frame = CGRect(x: originX, y: 4, width: viewWidth, height: labelHeight)
            imageView.frame = CGRect(x: originX, y: labelHeight, width: viewWidth, height: imageHeight)
            subtitleLabel.frame = CGRect(x: originX, y: viewHeight - labelHeight - 4, width: viewWidth, height: labelHeight)
        } else if hasSubtitle {
            let labelHeight: CGFloat = ceil(viewHeight * 0.28)
            let imageHeight: CGFloat = viewHeight - labelHeight - 8
            imageView.frame = CGRect(x: originX, y: 8, width: viewWidth, height: imageHeight)
            subtitleLabel.frame = CGRect(x: originX, y: viewHeight - labelHeight - 6, width: viewWidth, height: labelHeight)
            titleLabel.frame = .zero
        } else if hasTitle {
            let labelHeight: CGFloat = ceil(viewHeight * 0.28)
            let imageHeight: CGFloat = viewHeight - labelHeight - 8
            titleLabel.frame = CGRect(x: originX, y: 6, width: viewWidth, height: labelHeight)
            imageView.frame = CGRect(x: originX, y: labelHeight + 6, width: viewWidth, height: imageHeight)
            subtitleLabel.frame = .zero
        } else {
            imageView.frame = CGRect(x: originX, y: 0, width: viewWidth, height: viewHeight)
            titleLabel.frame = .zero
            subtitleLabel.frame = .zero
        }
    }
}
