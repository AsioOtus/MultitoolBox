import Foundation



public protocol Request: CustomStringConvertible {
	var urlSession: URLSession { get }
	var urlRequest: URLRequest { get }
}



public protocol Response: CustomStringConvertible {
	var data: Data { get }
	var urlResponse: URLResponse { get }
	
	init (_ urlResponse: URLResponse, _ data: Data) throws
}
