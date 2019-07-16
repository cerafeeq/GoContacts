//
//  DataProviderTests.swift
//  GoContactsTests
//
//  Created by Rafeeq Ebrahim on 17/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import XCTest

@testable import GoContacts

class DataProviderTests: XCTestCase {
	var repository: ApiRepository = ApiRepository.shared
	var provider: DataProvider = DataProvider.shared

    override func setUp() {
		super.setUp()
	}

    override func tearDown() {
		super.tearDown()
	}

	func testUpdateInLocalStore() {
		var dict = [String : Any]()
		let id: Int32 = 35
		dict.updateValue(id, forKey: "id")
		dict.updateValue(false, forKey: "favorite")

		provider.updateInLocalStore(params: dict, imageUpdated: false)
	}

	func testSaveInLocalStore() {
		var dict = [String : Any]()
		dict.updateValue(35, forKey: "id")
		dict.updateValue("Shwan", forKey: "first_name")
		dict.updateValue("Swart", forKey: "last_name")
		dict.updateValue("+971 78491941", forKey: "phone_number")
		dict.updateValue("shawn@hope.com", forKey: "email")

		provider.saveInLocalStore(params: dict)
	}

	func testFetchContacts() {
		let session = URLSessionMock()
		repository.urlSession = session

		let bundle = Bundle(for: type(of: self))
		guard let path = bundle.path(forResource: "mockData1", ofType: "json") else { return }

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			session.data = data
		} catch {
			print("Error: \(error)")
		}

		var result: Error?

		provider.fetchContacts { (error) in
			result = error
		}

		XCTAssert(result == nil)
	}
}
