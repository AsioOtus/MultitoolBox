import Foundation



extension NetworkController.Logger.LogRecord {
	public enum Category {
		case request(URLSession, URLRequest)
		case response(Data, URLResponse)
		case error(NetworkController.Error)
		
		public var name: String {
			switch self {
			case .request(_, _):
				return "request"
			case .response(_, _):
				return "response"
			case .error(_):
				return "error"
			}
		}
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
