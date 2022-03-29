import Foundation

public protocol LogRecordStringConverter {
	func convert (_ record: NetworkController.Logger.LogRecord<NetworkController.Logger.BaseDetails>) -> String
}
