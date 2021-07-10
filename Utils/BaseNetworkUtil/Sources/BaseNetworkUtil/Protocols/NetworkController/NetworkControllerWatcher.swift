import Foundation



public protocol NetworkControllerWatcher {
	func onRequest (_ request: Request, _ requestInfo: NetworkController.RequestInfo)
	func onUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo)
	func onUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo)
	func onResponse (_ response: Response, _ requestInfo: NetworkController.RequestInfo)
	func onContent <Content> (_ content: Content, _ requestInfo: NetworkController.RequestInfo)
	
	func onUnmodifiedRequest (_ request: Request, _ requestInfo: NetworkController.RequestInfo)
	func onUnmodifiedUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo)
	func onModifiedUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo)
	func onModifiedResponse (_ response: Response, _ requestInfo: NetworkController.RequestInfo)
	func onModifiedContent <Content> (_ content: Content, _ requestInfo: NetworkController.RequestInfo)
	
	func onError (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo)
}



public extension NetworkControllerWatcher {
	func onRequest (_ request: Request, _ requestInfo: NetworkController.RequestInfo) { }
	func onUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) { }
	func onUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) { }
	func onResponse (_ response: Response, _ requestInfo: NetworkController.RequestInfo) { }
	func onContent <Content> (_ content: Content, _ requestInfo: NetworkController.RequestInfo) { }
	
	func onUnmodifiedRequest (_ request: Request, _ requestInfo: NetworkController.RequestInfo) { }
	func onUnmodifiedUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) { }
	func onModifiedUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) { }
	func onModifiedResponse (_ response: Response, _ requestInfo: NetworkController.RequestInfo) { }
	func onModifiedContent <Content> (_ content: Content, _ requestInfo: NetworkController.RequestInfo) { }
	
	func onError (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo) { }
}
