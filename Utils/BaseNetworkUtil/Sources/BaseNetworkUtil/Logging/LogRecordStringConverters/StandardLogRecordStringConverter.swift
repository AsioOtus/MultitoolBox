import Foundation

public struct StandardLogRecordStringConverter: LogRecordStringConverter {
	public var requestInfoConverter: (Controller.RequestInfo) -> String
	public var urlRequestConverter: (URLRequest) -> String
	public var urlResponseConverter: (URLResponse, Data) -> String
	public var controllerErrorConverter: (Controller.Error) -> String
	
	public init (
		requestInfoConverter: @escaping (Controller.RequestInfo) -> String,
		urlRequestConverter: @escaping (URLRequest) -> String,
		urlResponseConverter: @escaping (URLResponse, Data) -> String,
		controllerErrorConverter: @escaping (Controller.Error) -> String
	) {
		self.requestInfoConverter = requestInfoConverter
		self.urlRequestConverter = urlRequestConverter
		self.urlResponseConverter = urlResponseConverter
		self.controllerErrorConverter = controllerErrorConverter
	}
	
	public func convert (_ record: Controller.Logger.LogRecord) -> String {
		let requestInfoMessage = requestInfoConverter(record.requestInfo)
		let categoryMessage = convert(record.category)
		
		let messsage = "\(requestInfoMessage)\n\(categoryMessage)"
		return messsage
	}
	
	public func convert (_ category: Controller.Logger.LogRecord.Category) -> String {
		let message: String
		
		switch category {
		case .request(_, let urlRequest):
			message = "REQUEST – \(urlRequestConverter(urlRequest))"
		case .response(let data, let urlResponse):
			message = "RESPONSE – \(urlResponseConverter(urlResponse, data))"
		case .error(let controllerError):
			message = controllerErrorConverter(controllerError)
		}
		
		return message
	}
}
