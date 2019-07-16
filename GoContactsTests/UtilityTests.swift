//
//  UtilityTests.swift
//  GoContactsTests
//
//  Created by Rafeeq Ebrahim on 16/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import XCTest
@testable import GoContacts

class UtilityTests: XCTestCase {

    override func setUp() {
		super.setUp()
	}

    override func tearDown() {
		super.tearDown()
	}

	func testGenerateBoundary() {
		let str = generateBoundary()
		XCTAssert(str.count > 0)
	}

	func testCreateHttpBody() {
		let boundary = generateBoundary()
		let params = ["first_name" : "test", "last_name" : "test"]
		let image = UIImage(named: "placeholder")
		let media = Media(withImage: image!, forKey: "Test")
		let httpBody = createHttpBody(withParameters: params, media: [media!], boundary: boundary)
		XCTAssert(httpBody.count > 0)
	}

	func testRandomString() {
		let str = randomString(length: 12)
		XCTAssert(str.count == 12)
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
