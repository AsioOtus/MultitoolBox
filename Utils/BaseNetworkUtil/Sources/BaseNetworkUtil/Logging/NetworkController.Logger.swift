import Foundation

extension NetworkController {
	public struct Logger: NetworkControllerWatcher {
		public var logHandler: ControllerLogHandler
		
		public init (logHandler: ControllerLogHandler) {
			self.logHandler = logHandler
		}
		
		public func onUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) {
			logHandler.log(.init(requestInfo: requestInfo, category: .request(urlSession, urlRequest)))
		}
		
		public func onUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) {
			logHandler.log(.init(requestInfo: requestInfo, category: .response(data, urlResponse)))
		}
		
		public func onError (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo) {
			logHandler.log(.init(requestInfo: requestInfo, category: .error(error)))
		}
	}
}
