import Foundation

public struct DefaultHTTPURLResponseStringConverter: HTTPURLResponseStringConverter {
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
    
	public func convert (_ httpUrlResponse: HTTPURLResponse, body: Data?) -> String {
        var components = [String]()
        
        let firstLine = ShortHTTPURLResponseStringConverter().convert(httpUrlResponse, body: body)
        components.append(firstLine)
        
        let headers = dictionaryStringConverter.convert(httpUrlResponse.allHeaderFields)
        if !headers.isEmpty {
            components.append("")
            components.append(headers)
        }
        
        if let body = body, let bodyString = dataStringConverter.convert(body), !bodyString.isEmpty {
            components.append("")
            components.append(bodyString)
        }
        
        let string = components.joined(separator: "\n")
        return string
    }
}
