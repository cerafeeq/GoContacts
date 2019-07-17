//
//  MockCoreDataStack.swift
//  GoContactsTests
//
//  Created by Rafeeq Ebrahim on 17/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import CoreData

class MockCoreDataStack {

	private init() {}
	static let shared = MockCoreDataStack()

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "GoContacts")
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		description.shouldAddStoreAsynchronously = false // Make it simpler in test env

		container.persistentStoreDescriptions = [description]
		container.loadPersistentStores { (description, error) in
			// Check if the data store is in memory
			precondition( description.type == NSInMemoryStoreType )

			// Check if creating container wrong
			if let error = error {
				fatalError("Create an in-mem coordinator failed \(error)")
			}
		}
		return container
	}()

}
