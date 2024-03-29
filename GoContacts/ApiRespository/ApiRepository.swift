//
//  APIRepository.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

class ApiRepository {
	static let shared = ApiRepository()
	
	var urlSession = URLSession.shared
	
	func getContacts(completion: @escaping(_ jsonDict: [[String: Any]]?, _ error: Error?) -> ()) {
		let getURL = URL(string: Constants.baseURL + "/contacts.json")!
		urlSession.dataTask(with: getURL) { (data, response, error) in
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
		let getURL = URL(string: Constants.baseURL + "/contacts/\(id).json")!
		urlSession.dataTask(with: getURL) { (data, response, error) in
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

	func deleteContact(id :Int32, completion: @escaping (_ error: Error?) -> ()) {
		let deleteURL = URL(string: Constants.baseURL + "/contacts/\(id).json")!
		var request = URLRequest(url: deleteURL)
		request.httpMethod = "DELETE"

		urlSession.dataTask(with: request) { (data, response, error) in
			if let error = error {
				print ("Error: \(String(describing: error))")
				completion(error)
			}

			if let httpResponse = response as? HTTPURLResponse {
				if (httpResponse.statusCode == 204) {
					completion(nil)
				} else {
					let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnawailable.rawValue, userInfo: nil)
					completion(error)
				}
			}
		}.resume()
	}

	func createContact(params: [String: Any], image : UIImage?, completion: @escaping (_ data: Data?, _ error: Error?) -> ()) {
		guard let createURL = URL(string: Constants.baseURL + "/contacts.json") else { return }
		var request = URLRequest(url: createURL)
		request.httpMethod = "POST"

		var mediaArray = [Media]()

		if let image = image {
			let mediaImage = Media(withImage: image, forKey: "profile_pic")
			mediaArray.append(mediaImage!)
		}

		let boundary = generateBoundary()

		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

		let httpBody = createHttpBody(withParameters: params, media: mediaArray, boundary: boundary)
		request.httpBody = httpBody

		urlSession.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print ("Error: \(String(describing: error))")
				return
			}

			if let httpResponse = response as? HTTPURLResponse {
				if (httpResponse.statusCode == 201) {
					completion(data, nil)
				} else {
					let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnawailable.rawValue, userInfo: nil)
					completion(data, error)
				}
			}
		}.resume()
	}

	func updateContact(id: Int32, params: [String: Any], image : UIImage?, completion: @escaping (_ data: Data?, _ error: Error?) -> ()) {
		guard let updateURL = URL(string: Constants.baseURL + "/contacts/\(id).json") else { return }
		var request = URLRequest(url: updateURL)
		request.httpMethod = "PUT"

		var mediaArray = [Media]()

		if let image = image {
			let mediaImage = Media(withImage: image, forKey: "profile_pic")
			mediaArray.append(mediaImage!)
		}

		let boundary = generateBoundary()

		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

		let httpBody = createHttpBody(withParameters: params, media: mediaArray, boundary: boundary)
		request.httpBody = httpBody

		urlSession.dataTask(with: request) { (data, response, error) in
			if let error = error {
				print ("Error: \(String(describing: error))")
				completion(nil, error)
			}

			if let httpResponse = response as? HTTPURLResponse {
				if (httpResponse.statusCode == 200) {
					completion(data, nil)
				} else {
					let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnawailable.rawValue, userInfo: nil)
					completion(nil, error)
				}
			}
		}.resume()
	}
}
