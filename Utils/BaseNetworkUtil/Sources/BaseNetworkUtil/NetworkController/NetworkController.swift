import Foundation
import Combine

public class NetworkController: NetworkControllerProtocol {
	public let source: [String]
	public let label: String
	
	public var delegate: NetworkControllerDelegate? = nil
	public let logger = Logger()
	
	public init (
		source: [String] = [],
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.source = source + [Info.moduleName, String(describing: NetworkController.self)]
		self.label = label ?? "\(Info.moduleName).\(NetworkController.self) – \(file):\(line) – \(UUID().uuidString)"
	}
}

extension NetworkController {
	public func send <RequestDelegateType: RequestDelegate> (_ requestDelegate: RequestDelegateType) -> AnyPublisher<RequestDelegateType.ContentType, NetworkController.Error> {
		_send(requestDelegate)
	}
	
	func _send <RequestDelegateType: RequestDelegate> (_ requestDelegate: RequestDelegateType, source: [String] = []) -> AnyPublisher<RequestDelegateType.ContentType, NetworkController.Error> {
		let requestInfo = RequestInfo(source: self.source + source, controllerLabel: label, requestUuid: UUID())
		
		let requestPublisher = Just(requestDelegate)
			.tryMap { (requestDelegate: RequestDelegateType) -> RequestDelegateType.RequestType in
				try requestDelegate.request(requestInfo)
			}
			.handleEvents(receiveOutput: { (request: RequestDelegateType.RequestType) in self.logger.onUnmodifiedRequest.send(.init(requestInfo, request)) })
			.tryMap { (request: RequestDelegateType.RequestType) -> RequestDelegateType.RequestType in
				try self.delegate?.request(request, requestInfo) ?? request
			}
			.handleEvents(receiveOutput: { request in self.logger.onRequest.send(.init(requestInfo, request)) })
			
			
			
			.tryMap { (request: RequestDelegateType.RequestType) -> (URLSession, URLRequest) in
				try (requestDelegate.urlSession(request, requestInfo), requestDelegate.urlRequest(request, requestInfo))
			}
			.handleEvents(receiveOutput: { (urlSession: URLSession, urlRequest: URLRequest) in self.logger.onUnmodifiedUrlRequest.send(.init(requestInfo, (urlSession, urlRequest))) })
			.tryMap { (urlSession: URLSession, urlRequest: URLRequest) -> (URLSession, URLRequest) in
				let urlSession = try self.delegate?.urlSession(urlSession, requestInfo) ?? urlSession
				let urlRequest = try self.delegate?.urlRequest(urlRequest, requestInfo) ?? urlRequest
				return (urlSession, urlRequest)
			}
			.handleEvents(receiveOutput: { (urlSession: URLSession, urlRequest: URLRequest) in self.logger.onUrlRequest.send(.init(requestInfo, (urlSession, urlRequest))) })
			
			.mapError { Error(.preprocessingFailure($0)) }
			
			
			
			.flatMap { (urlSession: URLSession, urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), NetworkController.Error> in
				return urlSession.dataTaskPublisher(for: urlRequest)
					.mapError {	Error(.networkFailure(urlSession, urlRequest, $0)) }
					.eraseToAnyPublisher()
			}
			
			
			
			.handleEvents(receiveOutput: { (data: Data, urlResponse: URLResponse) in self.logger.onUrlResponse.send(.init(requestInfo, (data, urlResponse))) })
			.tryMap { (data: Data, urlResponse: URLResponse) -> (Data, URLResponse) in
				try (self.delegate?.data(data, requestInfo) ?? data, self.delegate?.urlResponse(urlResponse, requestInfo) ?? urlResponse)
			}
			.handleEvents(receiveOutput: { (data: Data, urlResponse: URLResponse) in self.logger.onModifiedUrlResponse.send(.init(requestInfo, (data, urlResponse))) })
			
			
			
			.tryMap { (data: Data, urlResponse: URLResponse) -> RequestDelegateType.ResponseType in
				try requestDelegate.response(data, urlResponse, requestInfo)
			}
			.handleEvents(receiveOutput: { (response: RequestDelegateType.ResponseType) in self.logger.onResponse.send(.init(requestInfo, response)) })
			.tryMap { (response: RequestDelegateType.ResponseType) -> RequestDelegateType.ResponseType in
				try self.delegate?.response(response, requestInfo) ?? response
			}
			.handleEvents(receiveOutput: { (response: RequestDelegateType.ResponseType) in self.logger.onModifiedResponse.send(.init(requestInfo, response)) })
			
			
			
			.tryMap { (response: RequestDelegateType.ResponseType) -> RequestDelegateType.ContentType in
				try requestDelegate.content(response, requestInfo)
			}
			.handleEvents(receiveOutput: { (content: RequestDelegateType.ContentType) in self.logger.onContent.send(.init(requestInfo, content)) })
			.tryMap { (content: RequestDelegateType.ContentType) -> RequestDelegateType.ContentType in
				try self.delegate?.content(content, requestInfo) ?? content
			}
			.handleEvents(receiveOutput: { (content: RequestDelegateType.ContentType) in self.logger.onModifiedContent.send(.init(requestInfo, content)) })
			
			
			
			.mapError {	Error(.postprocessingFailure($0)) }
			.handleEvents(
				receiveCompletion: { completion in
					if case .failure(let error) = completion {
						requestDelegate.error(error, requestInfo)
						self.delegate?.error(error, requestInfo)
						self.logger.onError.send(.init(requestInfo, error))
					}
				}
			)
		
		return requestPublisher.eraseToAnyPublisher()
	}
}

extension NetworkController {
	@discardableResult
	public func delegate (_ delegate: NetworkControllerDelegate) -> NetworkController {
		self.delegate = delegate
		return self
	}
	
	@discardableResult
	public func logging (_ logging: (Logger) -> ()) -> NetworkController {
		logging(logger)
		return self
	}
	
	@discardableResult
	public func logHandler (_ logHandler: ControllerLogHandler, _ cancellables: inout Set<AnyCancellable>) -> NetworkController {
		logger
			.onUrlRequest { logRecord in
				logHandler.log(.init(logRecord.requestInfo, .request(logRecord.details.urlSession, logRecord.details.urlRequest)))
			}
			.onUrlResponse { logRecord in
				logHandler.log(.init(logRecord.requestInfo, .response(logRecord.details.data, logRecord.details.urlResponse)))
			}
			.onError { logRecord in
				logHandler.log(.init(logRecord.requestInfo, .error(logRecord.details)))
			}
		
		return self
	}
}
