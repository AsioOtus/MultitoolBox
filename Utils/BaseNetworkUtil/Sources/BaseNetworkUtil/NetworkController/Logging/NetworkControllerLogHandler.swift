public protocol ControllerLogHandler {
	func log (_ logRecord: NetworkController.Logger.LogRecord<NetworkController.Logger.BaseDetails>)
}
