//
//  Data+Append.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import Foundation

extension Data {
	mutating func append(_ string: String) {
		if let data = string.data(using: .nonLossyASCII, allowLossyConversion: false) {
			append(data)
		}
	}
}
