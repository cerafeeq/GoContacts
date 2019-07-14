//
//  Utility.swift
//  GoContacts
//
//  Created by Rafeeq Ebrahim on 14/07/19.
//  Copyright © 2019 Rafeeq Ebrahim. All rights reserved.
//

import UIKit

func setGradientBackground(for cell: UITableViewCell) {
	let colorTop =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
	let colorBottom = UIColor(red: 80/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 0.55).cgColor

	let gradientLayer = CAGradientLayer()
	gradientLayer.colors = [colorTop, colorBottom]
	gradientLayer.locations = [0.0, 1.0]

	gradientLayer.frame = cell.bounds
	cell.layer.insertSublayer(gradientLayer, at:0)
}

func randomString(length: Int) -> String {
	let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	return String((0..<length).map{ _ in letters.randomElement()! })
}

func generateBoundary() -> String {
	return "Boundary-\(UUID().uuidString)"
}

func createHttpBody(withParameters params: [String : Any]?, media: [Media]?, boundary: String) -> Data {
	let lineBreak = "\r\n"
	var body = Data()

	body.append("--\(boundary + lineBreak)")

	if let parameters = params {
		for (key, value) in parameters {
			body.append("--\(boundary + lineBreak)")
			body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
			body.append("\(value)\r\n")
		}
	}

	if let media = media {
		for photo in media {
			body.append("--\(boundary + lineBreak)")
			body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
			body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
			body.append(photo.data)
			body.append(lineBreak)
		}
	}

	body.append("--\(boundary)--\(lineBreak)")

	return body
}
