import Foundation
import Combine

extension Controllers {
	public struct Base: BaseNetworkUtilController {
		public var settings = Settings()
		
		private let logger: Logger
		
		public init () {
			self.logger = .init("Base", settings.controllers.logging.loggingProvider)
		}
		
		public init (settings: Settings) {
			self.settings = settings
			self.logger = .init("Base", settings.controllers.logging.loggingProvider)
		}
		
		init (source: String) {
			self.logger = .init(source, settings.controllers.logging.loggingProvider)
		}
		
		init (settings: Settings, source: String) {
			self.settings = settings
			self.logger = .init(source, settings.controllers.logging.loggingProvider)
		}
		
		public func send <RequestDelegate: BaseNetworkUtil.RequestDelegate> (_ requestDelegate: RequestDelegate)
		-> AnyPublisher<RequestDelegate.Content, BaseNetworkError<RequestDelegate.Request>>
		{
			let requestPublisher = Just(requestDelegate)
				.tryMap { try $0.request() }
				.mapError { error in BaseNetworkError(error, or: .preprocessingFailure(error)) }
				.handleEvents(
					receiveOutput: { request in logger.log(request) }
				)
				
				.flatMap { request in
                    request.urlSession.dataTaskPublisher(for: request.urlRequest)
						.map { data, urlResponse in (data, urlResponse) }
						.mapError { error in BaseNetworkError(error, or: .responseFailure(request, error)) }
				}
				
				.tryMap { (data, urlResponse) in
					do {
						return (data, urlResponse, try RequestDelegate.Request.Response(urlResponse, data))
					} catch {
						throw BaseNetworkError(error, or: .postprocessingError(data, urlResponse, Error.responseCreationFailure(error)))
					}
				}
				.tryMap { (data: Data, urlResponse: URLResponse, response: RequestDelegate.Request.Response) in
					do {
						return (data, urlResponse, try requestDelegate.content(response))
					} catch {
						throw BaseNetworkError(error, or: .postprocessingError(data, urlResponse, Error.contentCreationFailure(error)))
					}
				}
				.mapError { $0 as! BaseNetworkError }
				.handleEvents(
					receiveOutput: { (data, urlResponse, content) in logger.log(data, urlResponse) },
					receiveCompletion: { completion in
						if case .failure(let error) = completion {
							logger.log(error)
						}
					}
				)
				.map { (data: Data, urlResponse: URLResponse, content: RequestDelegate.Content) in content }
			
			return requestPublisher.eraseToAnyPublisher()
		}
	}
}



extension Controllers.Base {
	enum Error: BaseNetworkUtilError {
		case responseCreationFailure(Swift.Error)
		case contentCreationFailure(Swift.Error)
	}
}
