import Foundation

public struct StandardLogRecordStringConverter: LogRecordStringConverter {
	public var requestInfoConverter: (NetworkController.RequestInfo) -> String
	public var urlRequestConverter: (URLRequest) -> String
	public var urlResponseConverter: (URLResponse, Data) -> String
	public var httpUrlResponseConverter: (HTTPURLResponse, Data) -> String
	public var controllerErrorConverter: (NetworkController.Error) -> String
	
	public init (
		requestInfoConverter: @escaping (NetworkController.RequestInfo) -> String,
		urlRequestConverter: @escaping (URLRequest) -> String,
		urlResponseConverter: @escaping (URLResponse, Data) -> String,
		httpUrlResponseConverter: @escaping (HTTPURLResponse, Data) -> String,
		controllerErrorConverter: @escaping (NetworkController.Error) -> String
	) {
		self.requestInfoConverter = requestInfoConverter
		self.urlRequestConverter = urlRequestConverter
		self.urlResponseConverter = urlResponseConverter
		self.httpUrlResponseConverter = httpUrlResponseConverter
		self.controllerErrorConverter = controllerErrorConverter
	}
	
	public func convert (_ record: NetworkController.Logger.LogRecord<NetworkController.Logger.BaseDetails>) -> String {
		let requestInfoMessage = requestInfoConverter(record.requestInfo)
		let categoryMessage = convert(record.details)
		
		let messsage = "\(requestInfoMessage)\n\(categoryMessage)\n"
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
