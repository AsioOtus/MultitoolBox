public protocol ControllerErrorStringConverter {
	func convert (_ error: NetworkError) -> String
}
