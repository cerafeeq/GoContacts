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
		let image = UIImage(named: "placeholder")
		media = Media(withImage: image!, forKey: "Test")
	}

    override func tearDown() {
		media = nil
		super.tearDown()
	}

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
