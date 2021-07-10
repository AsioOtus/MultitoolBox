public protocol ControllerErrorStringConverter {
	func convert (_ error: NetworkController.Error) -> String
}
