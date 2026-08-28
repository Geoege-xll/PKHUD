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

    public static let defaultSquareBaseViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 156.0, height: 156.0))

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
        imageView.tintColor = .label
        return imageView
    }()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.secondaryLabel
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

        let halfHeight = ceil(viewHeight / 2.0)
        let quarterHeight = ceil(viewHeight / 4.0)
        let threeQuarterHeight = ceil(viewHeight / 4.0 * 3.0)

        titleLabel.frame = CGRect(origin: CGPoint(x: originX, y: 0.0), size: CGSize(width: viewWidth, height: quarterHeight))
        imageView.frame = CGRect(origin: CGPoint(x: originX, y: quarterHeight), size: CGSize(width: viewWidth, height: halfHeight))
        subtitleLabel.frame = CGRect(origin: CGPoint(x: originX, y: threeQuarterHeight), size: CGSize(width: viewWidth, height: quarterHeight))
    }
}
