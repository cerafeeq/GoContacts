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

		self.profileImageView.sd_setImage(with: URL(string: contact.profilePic!), placeholderImage: UIImage(named: "placeholder"))

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
			}
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		setGradientBackground(for: viewCell!)

		super.viewWillAppear(animated)
	}

	@IBAction func favoriteTapped(_ sender: Any) {
		guard let contact = contact else { return }

		contact.favorite = !contact.favorite

		favoriteBtn.setImage(UIImage(named: (contact.favorite ? "favorite_selected" : "favorite")), for: .normal)

		let dict = ["favorite" : String(contact.favorite)]

		// TODO: update the Core Data record

		ApiRepository.shared.updateContact(id: contact.id, dict: dict)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldCount
    }
}
