//
//  String+Index.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import Foundation

extension String {

	func index(at position: Int, from start: Index? = nil) -> Index? {
		let startingIndex = start ?? startIndex
		return index(startingIndex, offsetBy: position, limitedBy: endIndex)
	}

	func character(at position: Int) -> Character? {
		guard position >= 0, let indexPosition = index(at: position) else {
			return nil
		}
		return self[indexPosition]
	}
}
