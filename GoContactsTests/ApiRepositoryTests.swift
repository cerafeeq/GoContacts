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

		let bundle = Bundle(for: type(of: self))
		guard let path = bundle.path(forResource: "mockData1", ofType: "json") else { return }

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			session.data = data
		} catch {
			print("Error: \(error)")
		}

		var results: [[String : Any]]?

		repository.getContacts { (jsonDict, error) in
			results = jsonDict
		}

		XCTAssert(results!.count == 2)
	}

	func testGetContact() {
		let session = URLSessionMock()
		repository.urlSession = session

		let bundle = Bundle(for: type(of: self))
		guard let path = bundle.path(forResource: "mockData2", ofType: "json") else { return }

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			session.data = data
		} catch {
			print("Error: \(error)")
		}

		var result: [String : Any]?

		repository.getContact(id: 35) { (jsonDict, error) in
			result = jsonDict
		}

		XCTAssertEqual(result!["id"] as! Int32, 35)
	}

	func testCreateContact() {
		let session = URLSessionMock()
		repository.urlSession = session

		var params = [String : String]()
		params.updateValue("Shwan", forKey: "first_name")
		params.updateValue("Swart", forKey: "last_name")
		params.updateValue("+971 78491941", forKey: "phone_number")
		params.updateValue("shawn@hope.com", forKey: "email")

		session.response = HTTPURLResponse(url: URL(string: Constants.baseURL)!, statusCode: 201, httpVersion: nil, headerFields: [:])

		var err: Error?

		repository.createContact(params: params, image: nil) { (_, error) in
			err = error
		}

		XCTAssert(err == nil)
	}

	func testUpdateContact() {
		let session = URLSessionMock()
		repository.urlSession = session

		var params = [String : String]()
		params.updateValue("+971 78491945", forKey: "phone_number")
		params.updateValue("shawn@hopenext.com", forKey: "email")

		session.response = HTTPURLResponse(url: URL(string: Constants.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])

		var err: Error?

		repository.updateContact(id: 35, params: params, image: nil) { (_, error) in
			err = error
		}

		XCTAssert(err == nil)
	}

	func testDeleteContact() {
		let session = URLSessionMock()
		repository.urlSession = session

		session.response = HTTPURLResponse(url: URL(string: Constants.baseURL)!, statusCode: 204, httpVersion: nil, headerFields: [:])

		var err: Error?

		repository.deleteContact(id: 1) { error in
			err = error
		}

		XCTAssert(err == nil)
	}
}
