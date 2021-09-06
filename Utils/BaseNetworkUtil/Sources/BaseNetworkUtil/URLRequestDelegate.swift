import Foundation

extension Data: Response {
	public var data: Data { self }
	public var urlResponse: URLResponse { .init() }
	
	public init (_ data: Data, _ urlResponse: URLResponse) throws {
		self = data
	}
}

extension URLRequest: RequestDelegate {
	public func request (_ requestInfo: NetworkController.RequestInfo) -> URLRequest {
		self
	}
		
	public func content (_ response: Data, _ requestInfo: NetworkController.RequestInfo) -> Data {
		response
	}
}
