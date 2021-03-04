import Foundation

public protocol Request {
	associatedtype Response: BaseNetworkUtil.Response
	
    var urlSession: URLSession { get }
    var urlRequest: URLRequest { get }
}

public extension Request {
    var urlSession: URLSession { URLSession(configuration: .default) }
}

public protocol Response {
    var urlResponse: URLResponse { get }
    var data: Data { get }
    
	init (_ urlResponse: URLResponse, _ data: Data) throws
}
