import Foundation
import Combine

public class NetworkController: NetworkControllerProtocol {
	public let source: [String]
	public let identificationInfo: IdentificationInfo
	
	public let logger = Logger()
	
	public init (
		source: [String] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.source = source
		self.identificationInfo = IdentificationInfo(
			module: Info.moduleName,
			type: String(describing: Self.self),
			file: file,
			line: line,
			label: label
		)
	}
}

extension NetworkController {
    public func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String? = nil) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = RequestInfo(
			uuid: UUID(),
			label: label,
			delegate: requestDelegate.name,
			source: [],
			controllers: []
		)
		return _send(requestDelegate, requestInfo)
	}
	
	func _send <RD: RequestDelegate> (_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = requestInfo
            .add(identificationInfo)
			.add(source)
		
		let requestPublisher = Just(requestDelegate)
			.tryMap { (requestDelegate: RD) -> RD.RequestType in
				try requestDelegate.request(requestInfo)
			}
			.tryMap { (request: RD.RequestType) -> (URLSession, URLRequest) in
				try (requestDelegate.urlSession(request, requestInfo), requestDelegate.urlRequest(request, requestInfo))
			}
            .mapError { NetworkError.preprocessing(error: $0) }
			.flatMap { (urlSession: URLSession, urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), NetworkError> in
				urlSession.dataTaskPublisher(for: urlRequest)
                    .mapError {	.networkFailure(urlSession, urlRequest, $0) }
					.eraseToAnyPublisher()
			}
        
			.tryMap { (data: Data, urlResponse: URLResponse) -> RD.ResponseType in
				try requestDelegate.response(data, urlResponse, requestInfo)
			}
			.tryMap { (response: RD.ResponseType) -> RD.ContentType in
				try requestDelegate.content(response, requestInfo)
			}
            .mapError {	NetworkError.preprocessing(error: $0) }
            .mapError { requestDelegate.error($0, requestInfo) }
		
		return requestPublisher.eraseToAnyPublisher()
	}
}

extension NetworkController {
	@discardableResult
	public func logging (_ logging: (Logger) -> ()) -> NetworkController {
		logging(logger)
		return self
	}
	
	@discardableResult
	public func logHandler (_ logHandler: ControllerLogHandler) -> NetworkController {
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
