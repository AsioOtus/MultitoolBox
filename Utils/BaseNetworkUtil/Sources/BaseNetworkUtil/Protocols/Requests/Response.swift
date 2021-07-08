import Foundation



public protocol Response: CustomStringConvertible {
	var data: Data { get }
	var urlResponse: URLResponse { get }
	
	init (_ urlResponse: URLResponse, _ data: Data) throws
}



extension Response {
	var description: String { urlResponse.description }
}
