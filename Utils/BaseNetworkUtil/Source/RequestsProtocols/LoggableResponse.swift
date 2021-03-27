import Foundation

public protocol LoggableResponse: Response {
	var httpUrlResponseStringConverter: HTTPURLResponseStringConverter { get }
	
    func logMessage (httpUrlResponseStringConverter: HTTPURLResponseStringConverter?) -> String
}

extension LoggableResponse {
	var httpUrlResponseStringConverter: HTTPURLResponseStringConverter { DefaultHTTPURLResponseStringConverter.default }
	
    func logMessage (httpUrlResponseStringConverter: HTTPURLResponseStringConverter? = nil) -> String {
		let httpUrlResponseStringConverter = httpUrlResponseStringConverter ?? self.httpUrlResponseStringConverter
		
		guard let httUrlResponse = urlResponse as? HTTPURLResponse else { return "" }
		let responseString = httpUrlResponseStringConverter.convert(httUrlResponse, body: data)
		return responseString
    }
}
