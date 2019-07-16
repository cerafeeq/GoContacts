//
//  AddEditProfileVC.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

protocol ContactSyncDelegate {
	func contactDidChange(params: [String: Any], imageModified: Bool)
}

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
	@IBOutlet var doneBtn: UIBarButtonItem!

	var delegate: ContactSyncDelegate!

	var textFields: [UITextField]!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
		self.profileImageView.clipsToBounds = true

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
		profileImageView.isUserInteractionEnabled = true
		profileImageView.addGestureRecognizer(tapGestureRecognizer)

		doneBtn.isEnabled = false

		textFields = [firstNameField, lastNameField, emailField, mobileField]

		for textField in textFields {
			textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		}

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
		setGradientBackground(for: viewCell, with: tableView.bounds)
		super.viewWillAppear(animated)
	}

	@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
	{
		let imageView = tapGestureRecognizer.view as! UIImageView
		let alert = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
			self.openCamera()
		}))

		alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
			self.openGallary()
		}))

		alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			alert.popoverPresentationController?.sourceView = imageView
			alert.popoverPresentationController?.sourceRect = imageView.bounds
			alert.popoverPresentationController?.permittedArrowDirections = .up
		default:
			break
		}

		self.present(alert, animated: true, completion: nil)
	}

	func openCamera()
	{
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
		{
			imagePicker.sourceType = UIImagePickerController.SourceType.camera
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
		else
		{
			let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}

	func openGallary()
	{
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
		imagePicker.allowsEditing = true
		self.present(imagePicker, animated: true, completion: nil)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldCount
    }

	//

	@IBAction func textFieldDidChange(_ sender: UITextField) {
		doneBtn.isEnabled = false
		guard let first = textFields[0].text, first != "" else {
			return
		}
		guard let second = textFields[1].text, second != "" else {
			return
		}
		guard let third = textFields[2].text, third != "" else {
			return
		}
		guard let forth = textFields[3].text, forth != "" else {
			return
		}

		doneBtn.isEnabled = true
	}

	@IBAction func cancelTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func doneTapped(_ sender: Any) {
		var dictContact = [String : String]()

		var image: UIImage?

		if (isImageModified) {
			image = profileImageView.image!
		}

		dictContact.updateValue(firstNameField.text!, forKey: "first_name")
		dictContact.updateValue(lastNameField.text!, forKey: "last_name")
		dictContact.updateValue(emailField.text!, forKey: "email")
		dictContact.updateValue(mobileField.text!, forKey: "phone_number")

		if (isEdit) {
			ApiRepository.shared.updateContact(id: contact!.id, params: dictContact, image: image) { serverResponse, data in
				if (serverResponse == .Failure) {
					DispatchQueue.main.async { [weak self] in
						let ac = UIAlertController(title: "Contacts", message: "Failed to create contact", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "OK", style: .default))
						self?.present(ac, animated: true)
					}
				} else {
					// if update is succesful, update in CoreData
					var jsonDict : [String : Any]?

					do {
						let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
						jsonDict = jsonObject as? [String: Any]
					} catch {
						return
					}

					DispatchQueue.main.async { [weak self] in
						DataProvider.shared.updateInLocalStore(params: jsonDict!, imageUpdated: self!.isImageModified)
						self?.dismiss(animated: true, completion: nil)
						self?.delegate.contactDidChange(params: jsonDict!, imageModified: self!.isImageModified)
					}
				}
			}
		} else {
			ApiRepository.shared.createContact(params: dictContact, image: image) { serverResponse, data in
				if (serverResponse == .Failure) {
					DispatchQueue.main.async { [weak self] in
						let ac = UIAlertController(title: "Contacts", message: "Failed to create contact", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "OK", style: .default))
						self?.present(ac, animated: true)
					}
				} else {
					//  If upload is successful, add contact to CoreData
					var jsonDict : [String : Any]?

					do {
						let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
						jsonDict = jsonObject as? [String: Any]
					} catch {
						return
					}

					DispatchQueue.main.async { [weak self] in
						DataProvider.shared.saveInLocalStore(params: jsonDict!)
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

		if (isEdit) {
			doneBtn.isEnabled = true
		}

		dismiss(animated: true, completion: nil)
	}
}
