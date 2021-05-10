import Foundation



public protocol RequestDelegate {
	associatedtype RequestType: Request
	associatedtype ResponseType: Response
	associatedtype ContentType
	
	func request (_ requestInfo: Controller.RequestInfo) throws -> RequestType
	
	func urlSession (_ request: RequestType, _ requestInfo: Controller.RequestInfo) throws -> URLSession
	func urlRequest (_ request: RequestType, _ requestInfo: Controller.RequestInfo) throws -> URLRequest
	
	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) throws -> ResponseType
	func content (_ response: ResponseType, _ requestInfo: Controller.RequestInfo) throws -> ContentType
	
	func error (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo)
}



public extension RequestDelegate {
	func urlSession (_ request: RequestType, _ requestInfo: Controller.RequestInfo) -> URLSession { request.urlSession }
	func urlRequest (_ request: RequestType, _ requestInfo: Controller.RequestInfo) -> URLRequest { request.urlRequest }
	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) throws -> ResponseType { try ResponseType(urlResponse, data) }
	func error (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo) { }
}
