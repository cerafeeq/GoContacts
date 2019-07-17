//
//  DataProvider.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import Foundation
import CoreData

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
	case networkUnawailable = 101
	case wrongDataFormat = 102
}

class DataProvider {
	private let persistentContainer: NSPersistentContainer
	private let repository: ApiRepository

	static let shared = DataProvider()

	private init() {
		self.persistentContainer = CoreDataStack.shared.persistentContainer
		self.repository = ApiRepository.shared
	}

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
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
			let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
			let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
			batchDeleteRequest.resultType = .resultTypeObjectIDs

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
					try contact.update(with: dict, imageUpdated: true)
				} catch {
					print("Error: \(error)\nThe stale object will be deleted.")
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

	func updateInLocalStore(object: Contact?, params: [String : Any], imageUpdated: Bool) {
		guard let object = object else { return }

		let viewContext = CoreDataStack.shared.persistentContainer.viewContext

		do {
			try object.update(with: params, imageUpdated: imageUpdated)
		} catch {
			print("Error: \(error)\nUnable to update.")
		}

		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				print("Error: \(error)\nCould not save Core Data context.")
			}
		}
	}

	func deleteFromLocalStore(object: Contact?) {
		guard let object = object else { return }
		let viewContext = CoreDataStack.shared.persistentContainer.viewContext
		viewContext.delete(object)

		do {
			try viewContext.save()
		} catch {
			print("Error: \(error)\nCould not save Core Data context.")
		}
	}


	func updateInLocalStore(params: [String : Any], imageUpdated: Bool) {
		guard let id = params["id"] as? Int32 else { return }

		// fetch the Contact from Core Data
		let viewContext = CoreDataStack.shared.persistentContainer.viewContext
		let contactFetch: NSFetchRequest<Contact> = Contact.fetchRequest()
		contactFetch.predicate = NSPredicate(format: "%K == \(id)", #keyPath(Contact.id))

		var currentContact: Contact?

		do {
			let results = try viewContext.fetch(contactFetch)
			if results.count > 0 {
				currentContact = results.first
			} else {
				return
			}
		} catch let error as NSError {
			print("Fetch error: \(error) description: \(error.userInfo)")
			return
		}

		do {
			try currentContact!.update(with: params, imageUpdated: imageUpdated)
		} catch {
			print("Error: \(error)\n Unable to update.")
		}

		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				print("Error: \(error)\nCould not save Core Data context.")
			}
			// viewContext.reset() // Reset the context to clean up the cache and low the im memory footprint.
		}
	}

	func saveInLocalStore(params: [String : Any]) {
		let viewContext = CoreDataStack.shared.persistentContainer.viewContext
		let contact = Contact(context: viewContext)

		do {
			try contact.update(with: params, imageUpdated: true)
		} catch {
			print("Error: \(error)\nThe quake object will be deleted.")
			viewContext.delete(contact)
		}
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				print("Error: \(error)\nCould not save Core Data context.")
			}
			viewContext.reset() // Reset the context to clean up the cache and low the memory footprint.
		}
	}
}
