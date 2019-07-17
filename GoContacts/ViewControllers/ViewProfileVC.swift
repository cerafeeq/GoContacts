//
//  ViewProfileVC.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

class ViewProfileVC: UITableViewController {
	let fieldCount = 3
	let sectionCount = 1
	var contact: Contact?

	private let baseURL = "http://gojek-contacts-app.herokuapp.com"

	@IBOutlet var profileImageView: UIImageView!
	@IBOutlet var nameLbl: UILabel!
	@IBOutlet var emailLbl: UILabel!
	@IBOutlet var favoriteBtn: UIButton!
	@IBOutlet var phoneLbl: UILabel!
	@IBOutlet var viewCell: UITableViewCell!

	override func viewDidLoad() {
        super.viewDidLoad()

		self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
		self.profileImageView.clipsToBounds = true

		guard let contact = self.contact else { return }

		nameLbl.text = contact.firstName! + " " + contact.lastName!
		self.phoneLbl.text = self.contact!.phoneNumber
		self.emailLbl.text = self.contact!.email

		profileImageView.sd_setImage(with: URL(string: contact.profilePic!), placeholderImage: UIImage(named: "placeholder"))

		if (contact.favorite) {
			favoriteBtn.setImage(UIImage(named: "favorite_selected"), for: .normal)
		}

		// fetch additional details from the web service
		ApiRepository.shared.getContact(id: contact.id) { (jsonDictionary, err) in
			guard let jsonDictionary = jsonDictionary else {
				return
			}

			self.contact!.phoneNumber = jsonDictionary["phone_number"] as? String
			self.contact!.email = jsonDictionary["email"] as? String

			DispatchQueue.main.async {
				self.phoneLbl.text = self.contact!.phoneNumber
				self.emailLbl.text = self.contact!.email

				// update in Core Data
				DataProvider.shared.updateInLocalStore(object: self.contact, params: jsonDictionary, imageUpdated: false)
			}
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		setGradientBackground(for: viewCell, with: tableView.bounds)

		super.viewWillAppear(animated)
	}

	@IBAction func favoriteTapped(_ sender: Any) {
		guard let contact = contact else { return }

		contact.favorite = !contact.favorite

		favoriteBtn.setImage(UIImage(named: (contact.favorite ? "favorite_selected" : "favorite")), for: .normal)

		let dict = ["favorite" : contact.favorite]

		ApiRepository.shared.updateContact(id: contact.id, params: dict, image: nil) { serverResponse, data in
			// TODO: update the Core Data record
		}
	}

	@IBAction func messageTapped(_ sender: Any) {
		guard let phoneNumber = self.contact?.phoneNumber else { return }

		UIApplication.shared.open(URL(string: "sms:" + phoneNumber)!, options: [:], completionHandler: nil)
	}

	@IBAction func callTapped(_ sender: Any) {
		guard let phoneNumber = self.contact!.phoneNumber else { return }

		UIApplication.shared.open(URL(string: "tel://" + phoneNumber)!, options: [:], completionHandler: nil)
	}

	@IBAction func emailTapped(_ sender: Any) {
		guard let email = self.contact?.email else { return }

		UIApplication.shared.open(URL(string: "mailto:" + email)!, options: [:], completionHandler: nil)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? AddEditProfileVC  {
			vc.contact = self.contact
			vc.delegate = self
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldCount
    }
}

extension ViewProfileVC: ContactSyncDelegate {
	func contactDidChange(params: [String: Any], imageModified: Bool) {
		guard let firstName = params["first_name"] as? String,
			let lastName = params["last_name"] as? String,
			let phoneNumber = params["phone_number"] as? String,
			let email = params["email"] as? String,
			let profilePic = params["profile_pic"] as? String
			else {
				return
		}

		nameLbl.text = firstName + " " + lastName
		phoneLbl.text = phoneNumber
		emailLbl.text = email

		if (!imageModified) {
			return
		}

		profileImageView.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(named: "placeholder"))
	}
}
