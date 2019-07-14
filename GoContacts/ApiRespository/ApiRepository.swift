//
//  APIRepository.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

enum ServerResponse {
	case Success
	case Failure
}

class ApiRepository {
	static let shared = ApiRepository()
	
	private let urlSession = URLSession.shared
	private let baseURL = "http://192.168.1.167:3000"
	
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

	func createContact(dict: [String: Any], image : UIImage?, completion: @escaping (ServerResponse) -> ()) {
		guard let createURL = URL(string: baseURL + "/contacts.json") else { return }
		var request = URLRequest(url: createURL)
		request.httpMethod = "POST"

		var mediaArray = [Media]()

		if let image = image {
			let mediaImage = Media(withImage: image, forKey: "profile_pic")
			mediaArray.append(mediaImage!)
		}

		let boundary = generateBoundary()

		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

		let httpBody = createHttpBody(withParameters: dict, media: mediaArray, boundary: boundary)
		request.httpBody = httpBody

		urlSession.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print ("Error: \(String(describing: error))")
				return
			}

			if let httpResponse = response as? HTTPURLResponse {
				if (httpResponse.statusCode == 201) {
					completion(ServerResponse.Success)
				} else {
					completion(ServerResponse.Failure)
				}
			}
		}.resume()
	}

	func updateContact(id: Int32, dict: [String: Any], image : UIImage?, completion: @escaping (ServerResponse) -> ()) {
		guard let updateURL = URL(string: baseURL + "/contacts/\(id).json") else { return }
		var request = URLRequest(url: updateURL)
		request.httpMethod = "PUT"

		var mediaArray = [Media]()

		if let image = image {
			let mediaImage = Media(withImage: image, forKey: "profile_pic")
			mediaArray.append(mediaImage!)
		}

		let boundary = generateBoundary()

		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

		let httpBody = createHttpBody(withParameters: dict, media: mediaArray, boundary: boundary)
		request.httpBody = httpBody

		urlSession.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print ("Error: \(String(describing: error))")
				return
			}

			if let httpResponse = response as? HTTPURLResponse {
				if (httpResponse.statusCode == 200) {
					completion(ServerResponse.Success)
				} else {
					completion(ServerResponse.Failure)
				}
			}
		}.resume()
	}
}
