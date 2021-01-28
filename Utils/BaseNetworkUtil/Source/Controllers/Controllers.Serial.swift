import Combine
import Foundation

extension Controllers {
	public struct Serial {
		public let baseController = Controllers.Base()
		private let semaphore = DispatchSemaphore(value: 1)
		
		public init () { }
		
		public func send <RequestDelegate: BaseNetworkUtil.RequestDelegate> (_ requestDelegate: RequestDelegate)
		-> AnyPublisher<RequestDelegate.Content, NetworkError>
		{
			semaphore.wait()
			
			let requestPublisher = baseController.send(requestDelegate)
				.handleEvents(receiveOutput: { _ in
					self.semaphore.signal()
				})
			
			return requestPublisher.eraseToAnyPublisher()
		}
	}
}
