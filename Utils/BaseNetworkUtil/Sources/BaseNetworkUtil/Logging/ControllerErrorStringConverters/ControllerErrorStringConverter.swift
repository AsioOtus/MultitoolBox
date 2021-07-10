public protocol ControllerErrorStringConverter {
	func convert (_ error: Controller.Error) -> String
}
