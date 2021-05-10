import Foundation

extension Controller {
	public struct Logger: ControllerWatcher {
		public var logHandler: ControllerLogHandler
		
		public func onUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) {
			logHandler.log(.init(requestInfo: requestInfo, category: .request(urlSession, urlRequest)))
		}
		
		public func onUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) {
			logHandler.log(.init(requestInfo: requestInfo, category: .response(data, urlResponse)))
		}
		
		public func onError (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo) {
			logHandler.log(.init(requestInfo: requestInfo, category: .error(error)))
		}
	}
}
