import Foundation



public protocol NetworkControllerDelegate {
	func request <RequestType: Request> (_ request: RequestType, _ requestInfo: RequestInfo) throws -> RequestType
	
	func urlSession (_ urlSession: URLSession, _ requestInfo: RequestInfo) throws -> URLSession
	func urlRequest (_ urlRequest: URLRequest, _ requestInfo: RequestInfo) throws -> URLRequest
	func data (_ data: Data, _ requestInfo: RequestInfo) throws -> Data
	func urlResponse (_ urlRequest: URLResponse, _ requestInfo: RequestInfo) throws -> URLResponse
	
	func response <ResponseType: Response> (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ResponseType
	func content <Content> (_ content: Content, _ requestInfo: RequestInfo) throws -> Content
	
	func error (_ error: Error, _ requestInfo: RequestInfo)
}



public extension NetworkControllerDelegate {
	func request <RequestType: Request> (_ request: RequestType, _ requestInfo: RequestInfo) throws -> RequestType { request }
	
	func urlSession (_ urlSession: URLSession, _ requestInfo: RequestInfo) throws -> URLSession { urlSession }
	func urlRequest (_ urlRequest: URLRequest, _ requestInfo: RequestInfo) throws -> URLRequest { urlRequest }
	func data (_ data: Data, _ requestInfo: RequestInfo) throws -> Data { data }
	func urlResponse (_ urlRequest: URLResponse, _ requestInfo: RequestInfo) throws -> URLResponse { urlRequest }
	
	func response <ResponseType: Response> (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ResponseType { response }
	func content <Content> (_ content: Content, _ requestInfo: RequestInfo) throws -> Content { content }
	
	func error (_ error: Error, _ requestInfo: RequestInfo) { }
}
