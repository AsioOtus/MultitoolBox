import Foundation

public protocol LogRecordStringConverter {
	func convert (_ record: Controller.Logger.LogRecord) -> String
}
