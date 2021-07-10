import Foundation

public protocol LogRecordStringConverter {
	func convert (_ record: NetworkController.Logger.LogRecord) -> String
}
