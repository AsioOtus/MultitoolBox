import Foundation
import Combine

extension Controllers {
	public struct Base {
		public var settings = Settings()
		
		public init () { }
		
		public init (settings: Settings) {
			self.settings = settings
		}
		
		public func send <RequestDelegate: BaseNetworkUtil.RequestDelegate> (_ requestDelegate: RequestDelegate)
		-> AnyPublisher<RequestDelegate.Content, BaseNetworkError>
		{
			let requestPublisher = Just(requestDelegate)
				.tryMap { try $0.request() }
				.tryMap { (try $0.urlSession(), try $0.urlRequest()) }
				.mapError { BaseNetworkError($0 as? BaseNetworkError, or: .processingFailure(.pre($0))) }
				.handleEvents(
					receiveOutput: { (urlSession, urlRequest) in settings.controllers.logger.log(urlSession, urlRequest) }
				)
				
				.flatMap { (urlSession: URLSession, urlRequest: URLRequest) in
					urlSession.dataTaskPublisher(for: urlRequest)
						.handleEvents(
							receiveOutput: { (data, urlResponse) in settings.controllers.logger.log(data, urlResponse) }
						)
						.mapError { error in BaseNetworkError.connectionFailure(error)
					}
				}
				
				.tryMap { try RequestDelegate.Request.Response($0.response, $0.data) }
				.tryMap { try requestDelegate.content($0) }
				.mapError { BaseNetworkError($0 as? BaseNetworkError, or: .processingFailure(.post($0))) }
				.handleEvents(
					receiveCompletion: { completion in
						if case .failure(let error) = completion {
							settings.controllers.logger.log(error)
						}
					}
				)
			
			return requestPublisher.eraseToAnyPublisher()
		}
	}
}
