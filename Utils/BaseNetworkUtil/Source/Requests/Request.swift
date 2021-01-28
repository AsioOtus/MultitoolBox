import Foundation

public protocol Request {
	associatedtype Response: BaseNetworkUtil.Response
	
	func session () throws -> URLSession
	func urlRequest () throws -> URLRequest
}

public extension Request {
	func session () throws -> URLSession { URLSession(configuration: .default) }
}

public protocol Response {
	init (_ urlResponse: URLResponse, _ data: Data) throws
}
