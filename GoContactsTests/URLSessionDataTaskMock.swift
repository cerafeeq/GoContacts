//
//  URLSessionDataTaskMock.swift
//  GoContactsTests
//
//  Created by Rafeeq Ebrahim on 16/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
	private let closure: () -> Void

	init(closure: @escaping () -> Void) {
		self.closure = closure
	}

	// We override the 'resume' method and simply call our closure
	// instead of actually resuming any task.
	override func resume() {
		closure()
	}
}
