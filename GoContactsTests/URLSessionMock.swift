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

	// Properties that enable us to set exactly what data or error
	// we want our mocked URLSession to return for any request.
	var data: Data?
	var error: Error?

	override func dataTask(
		with url: URL,
		completionHandler: @escaping CompletionHandler
		) -> URLSessionDataTask {
		let data = self.data
		let error = self.error

		return URLSessionDataTaskMock {
			completionHandler(data, nil, error)
		}
	}
}
