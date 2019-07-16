//
//  CoreDataStackTests.swift
//  GoContactsTests
//
//  Created by Rafeeq Ebrahim on 16/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import XCTest
@testable import GoContacts
import CoreData

var viewContext: NSManagedObjectContext?

class CoreDataStackTests: XCTestCase {

    override func setUp() {
		super.setUp()
		viewContext = CoreDataStack.shared.persistentContainer.viewContext
	}

    override func tearDown() {
		viewContext = nil
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
