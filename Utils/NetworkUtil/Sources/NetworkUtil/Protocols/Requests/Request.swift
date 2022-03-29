import Foundation

public protocol Request: CustomStringConvertible {
	var urlSession: URLSession { get }
	var urlRequest: URLRequest { get }
}

public extension Request {
	var urlSession: URLSession { .shared }
	
	var description: String { urlRequest.description }
}
