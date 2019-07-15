//
//  ContactsListVC.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class ContactsListVC: UITableViewController {
	private let contactCellId = "ContactsListCell"

	lazy var fetchedResultsController: NSFetchedResultsController<Contact> = {
		let fetchRequest = NSFetchRequest<Contact>(entityName:"Contact")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionIdentifier", ascending:true),
										NSSortDescriptor(key: "firstName", ascending:true)]

		let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
													managedObjectContext: DataProvider.shared.viewContext,
													sectionNameKeyPath: "sectionIdentifier", cacheName: nil)
		controller.delegate = self

		do {
			try controller.performFetch()
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}

		return controller
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		DataProvider.shared.fetchContacts { (error) in
			// TODO: Handle errors
		}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: contactCellId, for: indexPath) as! ContactsListViewCell
		let contact = fetchedResultsController.object(at: indexPath)

		cell.nameLbl.text = contact.firstName! + " " + contact.lastName!
		cell.favouriteImage.isHidden = !contact.favorite
		cell.thumbnailView.sd_setImage(with: URL(string: contact.profilePic!), placeholderImage: UIImage(named: "placeholder"))

		return cell
	}

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return fetchedResultsController.sectionIndexTitles
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let sectionInfo = fetchedResultsController.sections?[section]
		return sectionInfo?.name
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? ViewProfileVC {
			let indexPath = tableView.indexPathForSelectedRow
			vc.contact = fetchedResultsController.object(at: indexPath!)
		}
	}
}

extension ContactsListVC: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		tableView.reloadData()
	}
}
