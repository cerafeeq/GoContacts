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

	var isImageModified: Bool = false

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
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func doneTapped(_ sender: Any) {
		var dictContact = [String: String]()

		var image: UIImage?

		if (isImageModified) {
			image = profileImageView.image!
		}

		dictContact.updateValue(firstNameField.text!, forKey: "first_name")
		dictContact.updateValue(lastNameField.text!, forKey: "last_name")
		dictContact.updateValue(emailField.text!, forKey: "email")
		dictContact.updateValue(mobileField.text!, forKey: "phone_number")

		if (isEdit) {
			ApiRepository.shared.updateContact(id: contact!.id, dict: dictContact, image: image) { serverResponse in
				print(serverResponse)
				if (serverResponse == .Failure) {
					DispatchQueue.main.async { [weak self] in
						let ac = UIAlertController(title: "Contacts", message: "Failed to create contact", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "OK", style: .default))
						self?.present(ac, animated: true)
					}
				} else {
					DispatchQueue.main.async { [weak self] in
						self?.dismiss(animated: true, completion: nil)
					}
				}
			}
		} else {
			ApiRepository.shared.createContact(dict: dictContact, image: image) { serverResponse in
				print(serverResponse)
				if (serverResponse == .Failure) {
					DispatchQueue.main.async { [weak self] in
						let ac = UIAlertController(title: "Contacts", message: "Failed to create contact", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "OK", style: .default))
						self?.present(ac, animated: true)
					}
				} else {
					DispatchQueue.main.async { [weak self] in
						self?.dismiss(animated: true, completion: nil)
					}
				}
			}
		}
	}
}

extension AddEditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
		self.profileImageView.image = image
		self.isImageModified = true

		dismiss(animated: true, completion: nil)
	}
}
