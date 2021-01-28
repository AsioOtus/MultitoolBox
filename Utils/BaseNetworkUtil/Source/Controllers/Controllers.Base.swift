import Combine

extension Controllers {
	public struct Base {
		public func send <RequestDelegate: BaseNetworkUtil.RequestDelegate> (_ requestDelegate: RequestDelegate)
		-> AnyPublisher<RequestDelegate.Content, NetworkError>
		{
			let requestPublisher = Just(requestDelegate)
				.tryMap { try $0.request() }
				.tryMap { (try $0.session(), try $0.urlRequest()) }
				.mapError { NetworkError($0 as? NetworkError, or: .processingFailure(.pre($0))) }
				
				.flatMap { $0.dataTaskPublisher(for: $1).mapError { error in NetworkError.connectionFailure(error) } }
				
				.tryMap { try RequestDelegate.Request.Response($0.response, $0.data) }
				.tryMap { try requestDelegate.content($0) }
				.mapError { NetworkError($0 as? NetworkError, or: .processingFailure(.post($0))) }
			
			return requestPublisher.eraseToAnyPublisher()
		}
	}
}
