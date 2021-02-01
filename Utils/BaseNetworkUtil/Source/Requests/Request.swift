import Foundation

public protocol Request {
	associatedtype Response: BaseNetworkUtil.Response
	
	func urlSession () throws -> URLSession
	func urlRequest () throws -> URLRequest
}

public extension Request {
	func urlSession () throws -> URLSession { URLSession(configuration: .default) }
}

public protocol Response {
	init (_ urlResponse: URLResponse, _ data: Data) throws
}
