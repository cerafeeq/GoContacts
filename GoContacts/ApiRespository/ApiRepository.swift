//
//  APIRepository.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import Foundation

enum ServerResponse {
	case Success
	case Failure
}

class ApiRepository {
	static let shared = ApiRepository()
	
	private let urlSession = URLSession.shared
	private let baseURL = "http://localhost:3000"
	
	func getContacts(completion: @escaping(_ jsonDict: [[String: Any]]?, _ error: Error?) -> ()) {
		let contactsURL = URL(string: baseURL + "/contacts.json")!
		urlSession.dataTask(with: contactsURL) { (data, response, error) in
			if let error = error {
				completion(nil, error)
				return
			}
			
			guard let data = data else {
				completion(nil, error)
				return
			}
			
			do {
				let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
				guard let jsonDicts = jsonObject as? [[String: Any]] else {
					return
				}
				completion(jsonDicts, nil)
			} catch {
				completion(nil, error)
			}
		}.resume()
	}

	func getContact(id :Int32, completion: @escaping(_ jsonDict: [String: Any]?, _ error: Error?) -> ()) {
		let contactURL = URL(string: baseURL + "/contacts/\(id).json")!
		urlSession.dataTask(with: contactURL) { (data, response, error) in
			if let error = error {
				completion(nil, error)
				return
			}

			guard let data = data else {
				completion(nil, error)
				return
			}

			do {
				let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
				guard let jsonDict = jsonObject as? [String: Any] else {
					return
				}
				completion(jsonDict, nil)
			} catch {
				completion(nil, error)
			}
		}.resume()
	}

	func updateContact(id :Int32, dict: [String: String]) {
		let updateURL = URL(string: baseURL + "/contacts/\(id).json")!
		var urlRequest = URLRequest(url: updateURL)

		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

		urlRequest.httpMethod = "PUT"

		guard let postData = try? JSONEncoder().encode(dict) else {
			return
		}

		urlRequest.httpBody = postData

		urlSession.dataTask(with: urlRequest) { data, response, error in
			guard error == nil else {
				print ("Error: \(String(describing: error))")
				return
			}
		}.resume()
	}
}
