import Foundation

extension NetworkController.Logger {
	public enum BaseDetails {
		case request(URLSession, URLRequest)
		case response(Data, URLResponse)
		case error(NetworkController.Error)
		
		public var name: String {
			switch self {
			case .request:
				return "request"
			case .response:
				return "response"
			case .error:
				return "error"
			}
		}
	}
}


public extension NetworkController.Logger.LogRecord where Details == NetworkController.Logger.BaseDetails{
	func convert (_ converter: LogRecordStringConverter) -> String {
		converter.convert(self)
	}
}
