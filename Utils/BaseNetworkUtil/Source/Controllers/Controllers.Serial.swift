import Combine
import Foundation

extension Controllers {
	public struct Serial {
		public let baseController: Controllers.Base
		private let semaphore = DispatchSemaphore(value: 1)
		
		public init () {
			baseController = Controllers.Base()
		}
		
		public init (settings: Settings) {
			baseController = Controllers.Base(settings: settings)
		}
		
		public func send <RequestDelegate: BaseNetworkUtil.RequestDelegate> (_ requestDelegate: RequestDelegate)
		-> AnyPublisher<RequestDelegate.Content, BaseNetworkError>
		{
			semaphore.wait()
			
			let requestPublisher = baseController
				.send(requestDelegate)
				.map { content -> RequestDelegate.Content in
					DispatchQueue.global().sync { _ = semaphore.signal() }
					return content
				}
				
			
			return requestPublisher.eraseToAnyPublisher()
		}
	}
}
