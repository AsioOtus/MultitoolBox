struct DefaultURLResponseStringConverter: URLResponseStringConverter {
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
	
	func convert (_ urlResponse: URLResponse, body: Data?) -> String {
		var components = [String]()
		
		let firstLine = ShortURLResponseStringConverter().convert(urlResponse, body: body)
		components.append(firstLine)
		
		if let body = body, let bodyString = dataStringConverter.convert(body), !bodyString.isEmpty {
			components.append("")
			components.append(bodyString)
		}
		
		let string = components.joined(separator: "\n")
		return string
	}
}
