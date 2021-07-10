import Foundation



extension NetworkController.Logger.LogRecord {
	public enum Category {
		case request(URLSession, URLRequest)
		case response(Data, URLResponse)
		case error(NetworkController.Error)
	}
}



extension NetworkController.Logger {
	public struct LogRecord {
		public let requestInfo: NetworkController.RequestInfo
		public let category: Category
	}
}


public extension NetworkController.Logger.LogRecord {
	func convert (_ converter: LogRecordStringConverter) -> String {
		converter.convert(self)
	}
}
