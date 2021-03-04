import Foundation

protocol URLRequestStringConverter {
	func convert (_ urlRequest: URLRequest) -> String
}



struct HTTPURLResponseStringConverter {
	func convert (_ urlResponse: HTTPURLResponse, _ data: Data) -> String {
		let url = urlResponse.url?.absoluteString
		let code = urlResponse.classCode
		let codeDescription = urlResponse.className
		let headers = urlResponse.allHeaderFields.map{ "\($0.key): \($0.value)" }.joined(separator: "\n")
		let body = convertBody(data)
	}
	
	func convertBody (_ data: Data?) -> String? {
		guard let data = data else { return nil }
		
		if let json = json(data) {
			return json
		}
		
		if let string = string(data) {
			return string
		}
		
		let dataString = data.base64EncodedString()
		return dataString
	}
	
	func string (_ data: Data) -> String? {
		String(data: data, encoding: .utf8)
	}
	
	func json (_ data: Data) -> String? {
		let jsonSerializationOptions: JSONSerialization.WritingOptions
		
		if #available(iOS 13.0, *) {
			jsonSerializationOptions = [.prettyPrinted, .withoutEscapingSlashes]
		} else {
			jsonSerializationOptions = [.prettyPrinted, .fragmentsAllowed]
		}
		
		guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
			  let data = try? JSONSerialization.data(withJSONObject: object, options: jsonSerializationOptions),
			  let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
		
		return prettyPrintedString as String
	}
}


struct DefaultURLRequestConverter: URLRequestStringConverter {
	func convert (_ urlRequest: URLRequest) -> String {
		var components = [String]()
		
		let method = urlRequest.httpMethod
		let url = urlRequest.url?.absoluteString
		let headers = urlRequest.allHTTPHeaderFields?.map{ "\($0.key): \($0.value)" }.joined(separator: "\n")
		let body = convertBody(urlRequest.httpBody)
		
		var firstLine = ""
		
		if let url = url {
			firstLine += url
		} else {
			firstLine += "[No URL]"
		}
		
		if let method = method {
			firstLine = "\(method) \(firstLine)"
		} else {
			firstLine = "[No method] \(firstLine)"
		}
		
		components.append(firstLine)
		
		if let headers = headers {
			components.append(headers)
		}
		
		if let body = body {
			components.append("")
			components.append(body)
		}
		
		let string = components.joined(separator: "\n")
		
		return string
	}
	
	func convertBody (_ data: Data?) -> String? {
		guard let data = data else { return nil }
		
		if let json = json(data) {
			return json
		}
		
		if let string = string(data) {
			return string
		}
		
		let dataString = data.base64EncodedString()
		return dataString
	}
	
	func string (_ data: Data) -> String? {
		String(data: data, encoding: .utf8)
	}
	
	func json (_ data: Data) -> String? {
		let jsonSerializationOptions: JSONSerialization.WritingOptions
		
		if #available(iOS 13.0, *) {
			jsonSerializationOptions = [.prettyPrinted, .withoutEscapingSlashes]
		} else {
			jsonSerializationOptions = [.prettyPrinted, .fragmentsAllowed]
		}
		
		guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
			  let data = try? JSONSerialization.data(withJSONObject: object, options: jsonSerializationOptions),
			  let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
		
		return prettyPrintedString as String
	}
}

struct DataConverter {
	func string (_ data: Data) -> String? {
		String(data: data, encoding: .utf8)
	}
	
	func json (_ data: Data) -> String? {
		let jsonSerializationOptions: JSONSerialization.WritingOptions
		
		if #available(iOS 13.0, *) {
			jsonSerializationOptions = [.prettyPrinted, .withoutEscapingSlashes]
		} else {
			jsonSerializationOptions = [.prettyPrinted, .fragmentsAllowed]
		}
		
		guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
			  let data = try? JSONSerialization.data(withJSONObject: object, options: jsonSerializationOptions),
			  let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
		
		return prettyPrintedString as String
	}
}
