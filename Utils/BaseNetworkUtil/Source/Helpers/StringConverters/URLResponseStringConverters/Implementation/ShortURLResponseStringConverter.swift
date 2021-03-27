import Foundation

struct ShortURLResponseStringConverter: URLResponseStringConverter {
	func convert (_ urlResponse: URLResponse, body: Data?) -> String {
		let string = urlResponse.url?.absoluteString ?? "[No URL]"
		return string
	}
}
