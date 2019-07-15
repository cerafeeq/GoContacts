//
//  ContactsListViewCell.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

class ContactsListViewCell: UITableViewCell {
	
	@IBOutlet var thumbnailView: UIImageView!
	@IBOutlet var nameLbl: UILabel!
	@IBOutlet var favouriteImage: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code

		self.thumbnailView.layer.cornerRadius = self.thumbnailView.frame.size.width / 2
		self.thumbnailView.clipsToBounds = true
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
}
