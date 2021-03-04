public protocol LoggableRequest: Request {
	var urlRequestStringConverter: URLRequestStringConverter { get }
	
    func logMessage (urlRequestStringConverter: URLRequestStringConverter?) -> String
}

extension LoggableRequest {
	var urlRequestStringConverter: URLRequestStringConverter { DefaultURLRequestStringConverter.default }
	
	func logMessage (urlRequestStringConverter: URLRequestStringConverter? = nil) -> String {
		let urlRequestStringConverter = urlRequestStringConverter ?? self.urlRequestStringConverter
		return urlRequestStringConverter.convert(urlRequest)
    }
}
