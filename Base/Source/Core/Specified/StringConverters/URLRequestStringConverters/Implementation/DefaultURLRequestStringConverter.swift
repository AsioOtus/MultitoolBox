struct DefaultURLRequestStringConverter: URLRequestStringConverter {
	static let `default` = Self()
	
	let dataStringConverter: OptionalDataStringConverter
	let dictionaryStringConverter: DictionaryStringConverter
	
	init (
		dataStringConverter: OptionalDataStringConverter = CompositeOptionalDataStringConverter.default,
		dictionaryStringConverter: DictionaryStringConverter = MultilineDictionaryStringConverter.default
	) {
		self.dataStringConverter = dataStringConverter
		self.dictionaryStringConverter = dictionaryStringConverter
	}
	
	func convert (_ urlRequest: URLRequest) -> String {
		var components = [String]()
		
		let firstLine = ShortURLRequestStringConverter().convert(urlRequest)
		components.append(firstLine)
		
		if let headersDictionary = urlRequest.allHTTPHeaderFields {
			let headers = dictionaryStringConverter.convert(headersDictionary)
			
			if !headers.isEmpty {
				components.append("")
				components.append(headers)
			}
		}
		
		if let body = urlRequest.httpBody, let bodyString = dataStringConverter.convert(body), !bodyString.isEmpty {
			components.append("")
			components.append(bodyString)
		}
		
		let string = components.joined(separator: "\n")
		return string
	}
}
