import Foundation

extension NetworkController.Logger {
	public struct LogRecord<Details> {
		public let requestInfo: NetworkController.RequestInfo
		public let details: Details
		
		init (_ requestInfo: NetworkController.RequestInfo, _ details: Details) {
			self.requestInfo = requestInfo
			self.details = details
		}
	}
}
