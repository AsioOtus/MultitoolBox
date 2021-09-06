import Foundation



public protocol RequestDelegate {
	associatedtype RequestType: Request
	associatedtype ResponseType: Response
	associatedtype ContentType
	
	func request (_ requestInfo: NetworkController.RequestInfo) throws -> RequestType
	
	func urlSession (_ request: RequestType, _ requestInfo: NetworkController.RequestInfo) throws -> URLSession
	func urlRequest (_ request: RequestType, _ requestInfo: NetworkController.RequestInfo) throws -> URLRequest
	
	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) throws -> ResponseType
	func content (_ response: ResponseType, _ requestInfo: NetworkController.RequestInfo) throws -> ContentType
	
	func error (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo)
}



public extension RequestDelegate {
	func urlSession (_ request: RequestType, _ requestInfo: NetworkController.RequestInfo) -> URLSession { request.urlSession }
	func urlRequest (_ request: RequestType, _ requestInfo: NetworkController.RequestInfo) -> URLRequest { request.urlRequest }
	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) throws -> ResponseType { try ResponseType(data, urlResponse) }
	func error (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo) { }
}
