//
//  PKHUDWideBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDWideBaseView provides a wide base view, which you can subclass and add additional views to.
@MainActor
open class PKHUDWideBaseView: UIView {

    public static var defaultWideBaseViewFrame: CGRect {
        return CGRect(origin: .zero, size: PKHUD.wideSize)
    }

    public init() {
        super.init(frame: PKHUDWideBaseView.defaultWideBaseViewFrame)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
