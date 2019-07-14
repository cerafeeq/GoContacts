//
//  CoreDataStack.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import CoreData

class CoreDataStack {

	private init() {}
	static let shared = CoreDataStack()

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "GoContacts")

		container.loadPersistentStores(completionHandler: { (_, error) in
			guard let error = error as NSError? else { return }
			fatalError("Unresolved error: \(error), \(error.userInfo)")
		})

		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.viewContext.undoManager = nil
		container.viewContext.shouldDeleteInaccessibleFaults = true

		container.viewContext.automaticallyMergesChangesFromParent = true

		return container
	}()

}
