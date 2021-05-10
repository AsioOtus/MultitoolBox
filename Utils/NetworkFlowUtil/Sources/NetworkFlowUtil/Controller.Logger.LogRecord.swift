import Foundation



extension Controller.Logger.LogRecord {
	public enum Category {
		case request(URLSession, URLRequest)
		case response(Data, URLResponse)
		case error(Controller.Error)
	}
}



extension Controller.Logger {
	public struct LogRecord {
		public let requestInfo: Controller.RequestInfo
		public let category: Category
	}
}
