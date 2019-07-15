//
//  Contact+CoreDataProperties.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

	@objc var sectionIdentifier: String {
		get {
			guard let firstName = firstName, !firstName.isEmpty else { return ""}

			let firstChar = firstName[firstName.startIndex]
			return String(firstChar).uppercased()
		}
	}

	@NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var id: Int32
    @NSManaged public var profilePic: String?
    @NSManaged public var favorite: Bool

}
