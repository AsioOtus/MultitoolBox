import Foundation



public protocol Response: CustomStringConvertible {
	var data: Data { get }
	var urlResponse: URLResponse { get }
	
	init (_ data: Data, _ urlResponse: URLResponse) throws
}



public extension Response {
	var description: String { urlResponse.description }
}
