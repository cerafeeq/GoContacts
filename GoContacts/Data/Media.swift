//
//  Media.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

struct Media {
	let key: String
	let filename: String
	let data: Data
	let mimeType: String

	init?(withImage image: UIImage, forKey key: String) {
		self.key = key
		self.mimeType = "image/jpeg"
		self.filename = "photo\(randomString(length: 12)).jpeg"

		guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
		self.data = data
	}
}
