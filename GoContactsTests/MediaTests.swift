//
//  MediaTests.swift
//  GoContactsTests
//
//  Created by Rafeeq Ebrahim on 16/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import XCTest
@testable import GoContacts

class MediaTests: XCTestCase {
	var media: Media!

    override func setUp() {
		super.setUp()
	}

	func testInit() {
		let image = UIImage(named: "placeholder")
		media = Media(withImage: image!, forKey: "Test")
	}

    override func tearDown() {
		media = nil
		super.tearDown()
	}

}
