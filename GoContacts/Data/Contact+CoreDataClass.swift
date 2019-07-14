//
//  Contact+CoreDataClass.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
	func update(with jsonDictionary: [String: Any]) throws {
		guard let id = jsonDictionary["id"] as? Int32,
			let firstName = jsonDictionary["first_name"] as? String,
			let lastName = jsonDictionary["last_name"] as? String,
			let profilePic = jsonDictionary["profile_pic"] as? String,
			let favorite = jsonDictionary["favorite"] as? Bool
			else {
				throw NSError(domain: "", code: 100, userInfo: nil)
		}

		self.firstName = firstName
		self.id = id
		self.lastName = lastName
		self.favorite = favorite
		self.profilePic = profilePic
	}
}
