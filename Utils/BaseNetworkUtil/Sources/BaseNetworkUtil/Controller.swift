import Foundation
import Combine

public struct Controller: ControllerProtocol {
	public let source: [String]
	public let label: String
	
	public var delegate: ControllerDelegate?
	public var watchers: [ControllerWatcher]
	
	public init (delegate: ControllerDelegate? = nil, watchers: [ControllerWatcher] = [], source: [String] = [], file: String = #file, line: Int = #line) {
		self.source = source + ["NetworkFlowUtil", "Controller"]
		self.delegate = delegate
		self.watchers = watchers
		self.label = "\(Controller.self) – \(file):\(line)"
	}
	
	public func send <RequestDelegateType: RequestDelegate> (_ requestDelegate: RequestDelegateType) -> AnyPublisher<RequestDelegateType.ContentType, Controller.Error> {
		_send(requestDelegate)
	}
	
	func _send <RequestDelegateType: RequestDelegate> (_ requestDelegate: RequestDelegateType, source: [String] = []) -> AnyPublisher<RequestDelegateType.ContentType, Controller.Error> {
		let requestInfo = RequestInfo(source: self.source + source, controllerLabel: label, requestUuid: UUID())
		
		let requestPublisher = Just(requestDelegate)
			.tryMap { (requestDelegate: RequestDelegateType) -> RequestDelegateType.RequestType in
				try requestDelegate.request(requestInfo)
			}
			.handleEvents(receiveOutput: { (request: RequestDelegateType.RequestType) in watchers.forEach{ $0.onUnmodifiedRequest(request, requestInfo) } })
			.tryMap { (request: RequestDelegateType.RequestType) -> RequestDelegateType.RequestType in
				try delegate?.request(request, requestInfo) ?? request
			}
			.handleEvents(receiveOutput: { request in watchers.forEach{ $0.onRequest(request, requestInfo) } })
			
			
			
			.tryMap { (request: RequestDelegateType.RequestType) -> (URLSession, URLRequest) in
				try (requestDelegate.urlSession(request, requestInfo), requestDelegate.urlRequest(request, requestInfo))
			}
			.handleEvents(receiveOutput: { (urlSession: URLSession, urlRequest: URLRequest) in watchers.forEach{ $0.onUnmodifiedUrlRequest(urlSession, urlRequest, requestInfo) } })
			.tryMap { (urlSession: URLSession, urlRequest: URLRequest) -> (URLSession, URLRequest) in
				let urlSession = try delegate?.urlSession(urlSession, requestInfo) ?? urlSession
				let urlRequest = try delegate?.urlRequest(urlRequest, requestInfo) ?? urlRequest
				return (urlSession, urlRequest)
			}
			.handleEvents(receiveOutput: { (urlSession: URLSession, urlRequest: URLRequest) in watchers.forEach{ $0.onUrlRequest(urlSession, urlRequest, requestInfo) } })
			
			.mapError { Error(.preprocessingFailure($0)) }
			
			
			
			.flatMap { (urlSession: URLSession, urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Controller.Error> in
				return urlSession.dataTaskPublisher(for: urlRequest)
					.mapError {	Error(.networkFailure(urlSession, urlRequest, $0)) }
					.eraseToAnyPublisher()
			}
			
			
			
			.handleEvents(receiveOutput: { (data: Data, urlResponse: URLResponse) in watchers.forEach{ $0.onUrlResponse(data, urlResponse, requestInfo) } })
			.tryMap { (data: Data, urlResponse: URLResponse) -> (Data, URLResponse) in
				try (delegate?.data(data, requestInfo) ?? data, delegate?.urlResponse(urlResponse, requestInfo) ?? urlResponse)
			}
			.handleEvents(receiveOutput: { (data: Data, urlResponse: URLResponse) in watchers.forEach{ $0.onModifiedUrlResponse(data, urlResponse, requestInfo) } })
			
			
			
			.tryMap { (data: Data, urlResponse: URLResponse) -> RequestDelegateType.ResponseType in
				try requestDelegate.response(data, urlResponse, requestInfo)
			}
			.handleEvents(receiveOutput: { (response: RequestDelegateType.ResponseType) in watchers.forEach{ $0.onResponse(response, requestInfo) } })
			.tryMap { (response: RequestDelegateType.ResponseType) -> RequestDelegateType.ResponseType in
				try delegate?.response(response, requestInfo) ?? response
			}
			.handleEvents(receiveOutput: { (response: RequestDelegateType.ResponseType) in watchers.forEach{ $0.onModifiedResponse(response, requestInfo) } })
			
			
			
			.tryMap { (response: RequestDelegateType.ResponseType) -> RequestDelegateType.ContentType in
				try requestDelegate.content(response, requestInfo)
			}
			.handleEvents(receiveOutput: { (content: RequestDelegateType.ContentType) in watchers.forEach{ $0.onContent(content, requestInfo) } })
			.tryMap { (content: RequestDelegateType.ContentType) -> RequestDelegateType.ContentType in
				try delegate?.content(content, requestInfo) ?? content
			}
			.handleEvents(receiveOutput: { (content: RequestDelegateType.ContentType) in watchers.forEach{ $0.onModifiedContent(content, requestInfo) } })
			
			
			
			.mapError {	Error(.postprocessingFailure($0)) }
			.handleEvents(
				receiveCompletion: { completion in
					if case .failure(let error) = completion {
						requestDelegate.error(error, requestInfo)
						delegate?.error(error, requestInfo)
						watchers.forEach{ $0.onError(error, requestInfo) }
					}
				}
			)
		
		return requestPublisher.eraseToAnyPublisher()
	}
}
