//
//  URLSessionMock.swift
//  GoContactsTests
//
//  Created by Rafeeq Ebrahim on 16/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import Foundation

class URLSessionMock: URLSession {
	typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

	var data: Data?
	var error: Error?
	var response: URLResponse?

	override func dataTask(
		with url: URL,
		completionHandler: @escaping CompletionHandler
		) -> URLSessionDataTask {
		let data = self.data
		let error = self.error
		let response = self.response

		return URLSessionDataTaskMock {
			completionHandler(data, response, error)
		}
	}

	override func dataTask(
		with request: URLRequest,
		completionHandler completion: @escaping CompletionHandler
		) -> URLSessionDataTask {
		let data = self.data
		let error = self.error
		let response = self.response

		return URLSessionDataTaskMock {
			completion(data, response, error)
		}
	}
}
