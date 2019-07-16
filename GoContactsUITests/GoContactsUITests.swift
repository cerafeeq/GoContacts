//
//  GoContactsUITests.swift
//  GoContactsUITests
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import XCTest
var app: XCUIApplication!

class GoContactsUITests: XCTestCase {

    override func setUp() {
		app = XCUIApplication()
		app.launch()
	}

	func testNewContact() {
		let app = XCUIApplication()
		app.launch()
		app.buttons["Add"].tap()

		let firstNameField = app.textFields["First Name"]
		let firstName = "Henry"
		firstNameField.tap()
		firstNameField.typeText(firstName)

		let lastNameField = app.textFields["Last Name"]
		let lastName = "Mathew"
		lastNameField.tap()
		lastNameField.typeText(lastName)

		let mobileField = app.textFields["Mobile"]
		let mobile = "+971 569901801"
		mobileField.tap()
		mobileField.typeText(mobile)

		let emailField = app.textFields["Email"]
		let email = "test@gmail.com"
		emailField.tap()
		emailField.typeText(email)

		app.buttons["Done"].tap()
	}

	func testNewContactCancelTap() {
		let app = XCUIApplication()
		app.launch()
		app.buttons["Add"].tap()
		app.buttons["Cancel"].tap()
	}

	func testContact() {
		let app = XCUIApplication()
		app.launch()
		let cell = app.tables.cells.element(boundBy: 2)
		cell.tap()
	}

	func testContactFavoriteTap() {
		let app = XCUIApplication()
		app.launch()
		let cell = app.tables.cells.element(boundBy: 2)
		cell.tap()
		app.buttons["Favorite"].tap()
	}

	func testContactCallTap() {
		let app = XCUIApplication()
		app.launch()
		let cell = app.tables.cells.element(boundBy: 2)
		cell.tap()
		app.buttons["Call"].tap()
	}

	func testContactMessageTap() {
		let app = XCUIApplication()
		app.launch()
		let cell = app.tables.cells.element(boundBy: 2)
		cell.tap()
		app.buttons["Message"].tap()
	}

	func testContactEmailTap() {
		let app = XCUIApplication()
		app.launch()
		let cell = app.tables.cells.element(boundBy: 2)
		cell.tap()
		app.buttons["Email"].tap()
	}

	func testEditContact() {
		let app = XCUIApplication()
		app.launch()
		let cell = app.tables.cells.element(boundBy: 3)
		cell.tap()
		app.buttons["Edit"].tap()

		let mobileField = app.textFields["Mobile"]
		let mobile = "+971 569901801"
		mobileField.buttons["Clear text"].tap()
		mobileField.tap()
		mobileField.typeText(mobile)

		let emailField = app.textFields["Email"]
		let email = "test@gmail.com"
		emailField.buttons["Clear text"].tap()
		emailField.tap()
		emailField.typeText(email)

		app.buttons["Done"].tap()
	}
}
