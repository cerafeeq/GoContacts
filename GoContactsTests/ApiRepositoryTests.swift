//
//  ApiRepositoryTests.swift
//  GoContactsTests
//
//  Created by Rafeeq Ebrahim on 16/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import XCTest
@testable import GoContacts

class ApiRepositoryTests: XCTestCase {

	var repository: ApiRepository = ApiRepository.shared

    override func setUp() {
		super.setUp()
	}

    override func tearDown() {
		super.tearDown()
	}

	func testGetContacts() {
		repository.getContacts { (jsonDictionary, error) in
			XCTAssert(jsonDictionary!.count > 0)
		}
	}

	func testGetContact() {
		repository.getContact(id: 46) { (jsonDict, error) in
			// XCTAssertEqual(jsonDict!["id"] as! Int32, 46)
		}
	}

	func testCreateContact() {

	}

	func testUpdateContact() {

	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
