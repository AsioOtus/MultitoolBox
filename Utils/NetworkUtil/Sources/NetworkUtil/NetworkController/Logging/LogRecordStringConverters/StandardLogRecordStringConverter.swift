import Foundation

public struct StandardLogRecordStringConverter: LogRecordStringConverter {
	public var requestInfoConverter: (RequestInfo) -> String
	public var urlRequestConverter: (URLRequest) -> String
	public var urlResponseConverter: (URLResponse, Data) -> String
	public var httpUrlResponseConverter: (HTTPURLResponse, Data) -> String
	public var controllerErrorConverter: (NetworkError) -> String
	
	public init (
		requestInfo: @escaping (RequestInfo) -> String,
		urlRequest: @escaping (URLRequest) -> String,
		urlResponse: @escaping (URLResponse, Data) -> String,
		httpUrlResponse: @escaping (HTTPURLResponse, Data) -> String,
		controllerError: @escaping (NetworkError) -> String
	) {
		self.requestInfoConverter = requestInfo
		self.urlRequestConverter = urlRequest
		self.urlResponseConverter = urlResponse
		self.httpUrlResponseConverter = httpUrlResponse
		self.controllerErrorConverter = controllerError
	}
	
	public func convert (_ record: NetworkController.Logger.LogRecord<NetworkController.Logger.BaseDetails>) -> String {
		let requestInfoMessage = requestInfoConverter(record.requestInfo)
		let detailsMessage = convert(record.details)
		
		let messsage = "\(requestInfoMessage)\n\(detailsMessage)\n"
		return messsage
	}
	
	public func convert (_ category: NetworkController.Logger.BaseDetails) -> String {
		let message: String
		
		switch category {
		case .request(_, let urlRequest):
			message = "REQUEST – \(urlRequestConverter(urlRequest))"
		case .response(let data, let httpUrlResponse as HTTPURLResponse):
			message = "RESPONSE – \(httpUrlResponseConverter(httpUrlResponse, data))"
		case .response(let data, let urlResponse):
			message = "RESPONSE – \(urlResponseConverter(urlResponse, data))"
		case .error(let controllerError):
			message = controllerErrorConverter(controllerError)
		}
		
		return message
	}
}
