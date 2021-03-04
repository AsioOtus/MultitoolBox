public protocol URLRequestInfoContainable {
	var urlSession: URLSession { get }
	var urlRequest: URLRequest { get }
}

public protocol URLResponseInfoContainable {
	var urlResponse: URLResponse { get }
	var data: Data { get }
}
