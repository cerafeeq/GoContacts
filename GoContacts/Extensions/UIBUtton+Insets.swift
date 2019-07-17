//
//  UIBUtton+Insets.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 17/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

extension UIButton {
	func alignTextUnderImage(spacing: CGFloat = 6.0) {
		guard let image = imageView?.image, let label = titleLabel, let string = label.text else { return }

		titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0.0)
		let titleSize = string.size(withAttributes: [NSAttributedString.Key.font: label.font])
		imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
	}
}
