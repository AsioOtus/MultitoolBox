import Foundation



public protocol ControllerDelegate {
	func request <RequestType: Request> (_ request: RequestType, _ requestInfo: Controller.RequestInfo) throws -> RequestType
	
	func urlSession (_ urlSession: URLSession, _ requestInfo: Controller.RequestInfo) throws -> URLSession
	func urlRequest (_ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) throws -> URLRequest
	func data (_ data: Data, _ requestInfo: Controller.RequestInfo) throws -> Data
	func urlResponse (_ urlRequest: URLResponse, _ requestInfo: Controller.RequestInfo) throws -> URLResponse
	
	func response <ResponseType: Response> (_ response: ResponseType, _ requestInfo: Controller.RequestInfo) throws -> ResponseType
	func content <Content> (_ content: Content, _ requestInfo: Controller.RequestInfo) throws -> Content
	
	func error (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo)
}



public extension ControllerDelegate {
	func request <RequestType: Request> (_ request: RequestType, _ requestInfo: Controller.RequestInfo) throws -> RequestType { request }
	
	func urlSession (_ urlSession: URLSession, _ requestInfo: Controller.RequestInfo) throws -> URLSession { urlSession }
	func urlRequest (_ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) throws -> URLRequest { urlRequest }
	func data (_ data: Data, _ requestInfo: Controller.RequestInfo) throws -> Data { data }
	func urlResponse (_ urlRequest: URLResponse, _ requestInfo: Controller.RequestInfo) throws -> URLResponse { urlRequest }
	
	func response <ResponseType: Response> (_ response: ResponseType, _ requestInfo: Controller.RequestInfo) throws -> ResponseType { response }
	func content <Content> (_ content: Content, _ requestInfo: Controller.RequestInfo) throws -> Content { content }
	
	func error (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo) { }
}
