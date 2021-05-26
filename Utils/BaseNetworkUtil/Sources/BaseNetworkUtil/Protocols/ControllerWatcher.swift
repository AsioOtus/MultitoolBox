import Foundation



public protocol ControllerWatcher {
	func onRequest (_ request: Request, _ requestInfo: Controller.RequestInfo)
	func onUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo)
	func onUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo)
	func onResponse (_ response: Response, _ requestInfo: Controller.RequestInfo)
	func onContent <Content> (_ content: Content, _ requestInfo: Controller.RequestInfo)
	
	func onUnmodifiedRequest (_ request: Request, _ requestInfo: Controller.RequestInfo)
	func onUnmodifiedUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo)
	func onModifiedUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo)
	func onModifiedResponse (_ response: Response, _ requestInfo: Controller.RequestInfo)
	func onModifiedContent <Content> (_ content: Content, _ requestInfo: Controller.RequestInfo)
	
	func onError (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo)
}



public extension ControllerWatcher {
	func onRequest (_ request: Request, _ requestInfo: Controller.RequestInfo) { }
	func onUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) { }
	func onUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) { }
	func onResponse (_ response: Response, _ requestInfo: Controller.RequestInfo) { }
	func onContent <Content> (_ content: Content, _ requestInfo: Controller.RequestInfo) { }
	
	func onUnmodifiedRequest (_ request: Request, _ requestInfo: Controller.RequestInfo) { }
	func onUnmodifiedUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) { }
	func onModifiedUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) { }
	func onModifiedResponse (_ response: Response, _ requestInfo: Controller.RequestInfo) { }
	func onModifiedContent <Content> (_ content: Content, _ requestInfo: Controller.RequestInfo) { }
	
	func onError (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo) { }
}
