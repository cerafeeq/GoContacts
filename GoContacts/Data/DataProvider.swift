//
//  DataProvider.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import Foundation
import CoreData

class DataProvider {
	private let persistentContainer: NSPersistentContainer
	private let repository: ApiRepository

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	init(persistentContainer: NSPersistentContainer, repository: ApiRepository) {
		self.persistentContainer = persistentContainer
		self.repository = repository
	}

	func fetchContacts(completion: @escaping(Error?) -> Void) {
		repository.getContacts() { jsonDictionary, error in
			if let error = error {
				completion(error)
				return
			}

			guard let jsonDictionary = jsonDictionary else {
				completion(error)
				return
			}

			let taskContext = self.persistentContainer.newBackgroundContext()
			taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
			taskContext.undoManager = nil

			_ = self.syncContacts(jsonDictionary: jsonDictionary, taskContext: taskContext)

			completion(nil)
		}
	}

	private func syncContacts(jsonDictionary: [[String: Any]], taskContext: NSManagedObjectContext) -> Bool {
		var successfull = false
		taskContext.performAndWait {
			let matchingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
			let ids = jsonDictionary.map { $0["id"] as? Int }.compactMap { $0 }
			matchingRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [ids])

			let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingRequest)
			batchDeleteRequest.resultType = .resultTypeObjectIDs

			// Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
			do {
				let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult

				if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
					NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
														into: [self.persistentContainer.viewContext])
				}
			} catch {
				print("Error: \(error)\nCould not batch delete existing records.")
				return
			}

			// Create new records.
			for dict in jsonDictionary {

				guard let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: taskContext) as? Contact else {
					print("Error: Failed to create a new Contact object!")
					return
				}

				do {
					try contact.update(with: dict)
				} catch {
					print("Error: \(error)\nThe quake object will be deleted.")
					taskContext.delete(contact)
				}
			}

			// Save all the changes just made and reset the taskContext to free the cache.
			if taskContext.hasChanges {
				do {
					try taskContext.save()
				} catch {
					print("Error: \(error)\nCould not save Core Data context.")
				}
				taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
			}
			successfull = true
		}
		return successfull
	}
}