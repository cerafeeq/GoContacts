//
//  AddEditProfileVC.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

class AddEditProfileVC: UITableViewController {
	let fieldCount = 5
	let sectionCount = 1

	var contact: Contact?

	var isEdit: Bool = false

	@IBOutlet var profileImageView: UIImageView!
	@IBOutlet var firstNameField: UITextField!
	@IBOutlet var lastNameField: UITextField!
	@IBOutlet var mobileField: UITextField!
	@IBOutlet var emailField: UITextField!
	@IBOutlet var viewCell: UITableViewCell!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
		self.profileImageView.clipsToBounds = true

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
		profileImageView.isUserInteractionEnabled = true
		profileImageView.addGestureRecognizer(tapGestureRecognizer)

		guard let contact = contact else {
			return
		}

		isEdit = true

		firstNameField.text = contact.firstName
		lastNameField.text = contact.lastName
		mobileField.text = contact.phoneNumber
		emailField.text = contact.email
    }

	override func viewWillAppear(_ animated: Bool) {
		setGradientBackground(for: viewCell)
		super.viewWillAppear(animated)
	}

	@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
	{
		_ = tapGestureRecognizer.view as! UIImageView
		let imagePicker = UIImagePickerController()

		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			imagePicker.sourceType = .camera
		} else {
			imagePicker.sourceType = .photoLibrary
		}

		imagePicker.delegate = self
		present(imagePicker, animated: true, completion: nil)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldCount
    }

	//

	@IBAction func cancelTapped(_ sender: Any) {
	}

	@IBAction func doneTapped(_ sender: Any) {
	}
}

extension AddEditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

		self.profileImageView.image = image

		dismiss(animated: true, completion: nil)
	}
}
