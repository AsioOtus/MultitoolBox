import Foundation
import Combine

extension Controllers {
	public struct Base {
		public var settings = Settings()
		
		private let logger: Logger
		
		public init () {
			self.logger = .init("Base", settings.controllers.loggingProvider)
		}
		
		public init (settings: Settings) {
			self.settings = settings
			self.logger = .init("Base", settings.controllers.loggingProvider)
		}
		
		init (source: String) {
			self.logger = .init(source, settings.controllers.loggingProvider)
		}
		
		init (settings: Settings, source: String) {
			self.settings = settings
			self.logger = .init(source, settings.controllers.loggingProvider)
		}
		
		public func send <RequestDelegate: BaseNetworkUtil.RequestDelegate> (_ requestDelegate: RequestDelegate)
		-> AnyPublisher<RequestDelegate.Content, BaseNetworkError>
		{
			let requestPublisher = Just(requestDelegate)
				.tryMap { try $0.request() }
				.tryMap { (try $0.urlSession(), try $0.urlRequest()) }
				.mapError { BaseNetworkError($0 as? BaseNetworkError, or: .processingFailure(.pre($0))) }
				.handleEvents(
					receiveOutput: { (urlSession, urlRequest) in logger.log(urlSession, urlRequest) }
				)
				
				.flatMap { (urlSession: URLSession, urlRequest: URLRequest) in
					urlSession.dataTaskPublisher(for: urlRequest)
						.handleEvents(
							receiveOutput: { (data, urlResponse) in logger.log(data, urlResponse) }
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
							logger.log(error)
						}
					}
				)
			
			return requestPublisher.eraseToAnyPublisher()
		}
	}
}
