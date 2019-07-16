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
		let session = URLSessionMock()
		repository.urlSession = session

		guard let path = Bundle.main.path(forResource: "mockData1", ofType: "json") else { return }

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			session.data = data
		} catch {
			print("Error: \(error)")
		}

		repository.getContacts { (jsonDictionary, error) in
			XCTAssert(jsonDictionary!.count == 2)
		}
	}

	func testGetContact() {
		let session = URLSessionMock()
		repository.urlSession = session

		guard let path = Bundle.main.path(forResource: "mockData1", ofType: "json") else { return }

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			session.data = data
		} catch {
			print("Error: \(error)")
		}

		repository.getContact(id: 35) { (jsonDict, error) in
			XCTAssertEqual(jsonDict!["id"] as! Int32, 35)
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
