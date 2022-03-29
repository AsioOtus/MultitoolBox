import Foundation

extension NetworkController.Logger {
	public struct LogRecord<Details> {
		public let requestInfo: RequestInfo
		public let details: Details
		
		init (_ requestInfo: RequestInfo, _ details: Details) {
			self.requestInfo = requestInfo
			self.details = details
		}
	}
}
