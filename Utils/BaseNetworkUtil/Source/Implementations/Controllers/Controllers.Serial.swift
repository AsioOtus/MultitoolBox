import Combine
import Foundation

extension Controllers {
	public struct Serial: BaseNetworkUtilController {
		public let baseController: Controllers.Base
		private let semaphore = DispatchSemaphore(value: 1)
		
		public init () {
			baseController = Controllers.Base(source: "Serial")
		}
		
		public init (settings: Settings) {
			baseController = Controllers.Base(settings: settings, source: "Serial")
		}
		
		public func send <RequestDelegate: BaseNetworkUtil.RequestDelegate> (_ requestDelegate: RequestDelegate)
        -> AnyPublisher<RequestDelegate.Content, BaseNetworkError<RequestDelegate.Request>>
		where RequestDelegate.Request: LoggableRequest, RequestDelegate.Request.Response: LoggableResponse
		{
			semaphore.wait()
			
			let requestPublisher = baseController
				.send(requestDelegate)
				.map { content -> RequestDelegate.Content in
					DispatchQueue.global().sync { _ = semaphore.signal() }
					return content
				}
				.mapError { error -> BaseNetworkError<RequestDelegate.Request> in
					DispatchQueue.global().sync { _ = semaphore.signal() }
					return error
				}
				
			
			return requestPublisher.eraseToAnyPublisher()
		}
	}
}
