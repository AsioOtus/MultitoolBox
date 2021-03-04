protocol URLResponseStringConverter {
	func convert (_ urlResponse: URLResponse, body: Data?) -> String
}
