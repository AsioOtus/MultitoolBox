import Foundation



public protocol NetworkControllerDelegate {
	func request <RequestType: Request> (_ request: RequestType, _ requestInfo: NetworkController.RequestInfo) throws -> RequestType
	
	func urlSession (_ urlSession: URLSession, _ requestInfo: NetworkController.RequestInfo) throws -> URLSession
	func urlRequest (_ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) throws -> URLRequest
	func data (_ data: Data, _ requestInfo: NetworkController.RequestInfo) throws -> Data
	func urlResponse (_ urlRequest: URLResponse, _ requestInfo: NetworkController.RequestInfo) throws -> URLResponse
	
	func response <ResponseType: Response> (_ response: ResponseType, _ requestInfo: NetworkController.RequestInfo) throws -> ResponseType
	func content <Content> (_ content: Content, _ requestInfo: NetworkController.RequestInfo) throws -> Content
	
	func error (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo)
}



public extension NetworkControllerDelegate {
	func request <RequestType: Request> (_ request: RequestType, _ requestInfo: NetworkController.RequestInfo) throws -> RequestType { request }
	
	func urlSession (_ urlSession: URLSession, _ requestInfo: NetworkController.RequestInfo) throws -> URLSession { urlSession }
	func urlRequest (_ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) throws -> URLRequest { urlRequest }
	func data (_ data: Data, _ requestInfo: NetworkController.RequestInfo) throws -> Data { data }
	func urlResponse (_ urlRequest: URLResponse, _ requestInfo: NetworkController.RequestInfo) throws -> URLResponse { urlRequest }
	
	func response <ResponseType: Response> (_ response: ResponseType, _ requestInfo: NetworkController.RequestInfo) throws -> ResponseType { response }
	func content <Content> (_ content: Content, _ requestInfo: NetworkController.RequestInfo) throws -> Content { content }
	
	func error (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo) { }
}
