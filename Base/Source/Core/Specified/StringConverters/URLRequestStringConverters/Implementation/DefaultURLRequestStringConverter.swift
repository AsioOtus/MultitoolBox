import Foundation

public struct DefaultURLRequestStringConverter: URLRequestStringConverter {
	public static let `default` = Self()
	
	public let dataStringConverter: OptionalDataStringConverter
	public let dictionaryStringConverter: DictionaryStringConverter
	
	public init (
		dataStringConverter: OptionalDataStringConverter = CompositeOptionalDataStringConverter.default,
		dictionaryStringConverter: DictionaryStringConverter = MultilineDictionaryStringConverter.default
	) {
		self.dataStringConverter = dataStringConverter
		self.dictionaryStringConverter = dictionaryStringConverter
	}
	
	public func convert (_ urlRequest: URLRequest) -> String {
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
