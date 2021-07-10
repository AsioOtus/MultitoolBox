public protocol RequestInfoStringConverter {
	func convert (_ requestInfo: NetworkController.RequestInfo) -> String
}
