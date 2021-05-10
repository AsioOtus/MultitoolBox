import Foundation

public struct CustomizableControllerWatcher: ControllerWatcher {
	public var onRequest: (_ request: Request, _ requestInfo: Controller.RequestInfo) -> Void
	public var onUrlRequest: (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) -> Void
	public var onUrlResponse: (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) -> Void
	public var onResponse: (_ response: Response, _ requestInfo: Controller.RequestInfo) -> Void
	public var onContent: (_ content: Any, _ requestInfo: Controller.RequestInfo) -> Void
	
	public var onUnmodifiedRequest: (_ request: Request, _ requestInfo: Controller.RequestInfo) -> Void
	public var onUnmodifiedUrlRequest: (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) -> Void
	public var onModifiedUrlResponse: (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) -> Void
	public var onModifiedResponse: (_ response: Response, _ requestInfo: Controller.RequestInfo) -> Void
	public var onModifiedContent: (_ content: Any, _ requestInfo: Controller.RequestInfo) -> Void
	
	public var onError: (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo) -> Void
	
	
	
	public init (
		onRequest: @escaping (Request, Controller.RequestInfo) -> Void,
		onUrlRequest: @escaping (URLSession, URLRequest, Controller.RequestInfo) -> Void,
		onUrlResponse: @escaping (Data, URLResponse, Controller.RequestInfo) -> Void,
		onResponse: @escaping (Response, Controller.RequestInfo) -> Void,
		onContent: @escaping (Any, Controller.RequestInfo) -> Void,
		onUnmodifiedRequest: @escaping (Request, Controller.RequestInfo) -> Void,
		onUnmodifiedUrlRequest: @escaping (URLSession, URLRequest, Controller.RequestInfo) -> Void,
		onModifiedUrlResponse: @escaping (Data, URLResponse, Controller.RequestInfo) -> Void,
		onModifiedResponse: @escaping (Response, Controller.RequestInfo) -> Void,
		onModifiedContent: @escaping (Any, Controller.RequestInfo) -> Void,
		onError: @escaping (Controller.Error, Controller.RequestInfo) -> Void
	) {
		self.onRequest = onRequest
		self.onUrlRequest = onUrlRequest
		self.onUrlResponse = onUrlResponse
		self.onResponse = onResponse
		self.onContent = onContent
		self.onUnmodifiedRequest = onUnmodifiedRequest
		self.onUnmodifiedUrlRequest = onUnmodifiedUrlRequest
		self.onModifiedUrlResponse = onModifiedUrlResponse
		self.onModifiedResponse = onModifiedResponse
		self.onModifiedContent = onModifiedContent
		self.onError = onError
	}
	
	
	
	public func onRequest (_ request: Request, _ requestInfo: Controller.RequestInfo) { onRequest(request, requestInfo) }
	public func onUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) { onUrlRequest(urlSession, urlRequest, requestInfo) }
	public func onUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) { onUrlResponse(data, urlResponse, requestInfo) }
	public func onResponse (_ response: Response, _ requestInfo: Controller.RequestInfo) { onResponse(response, requestInfo) }
	public func onContent <Content> (_ content: Content, _ requestInfo: Controller.RequestInfo) { onContent(content as Any, requestInfo) }
	
	public func onUnmodifiedRequest (_ request: Request, _ requestInfo: Controller.RequestInfo) { onUnmodifiedRequest(request, requestInfo) }
	public func onUnmodifiedUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: Controller.RequestInfo) { onUnmodifiedUrlRequest(urlSession, urlRequest, requestInfo) }
	public func onModifiedUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: Controller.RequestInfo) { onModifiedUrlResponse(data, urlResponse, requestInfo) }
	public func onModifiedResponse (_ response: Response, _ requestInfo: Controller.RequestInfo) { onModifiedResponse(response, requestInfo) }
	public func onModifiedContent <Content> (_ content: Content, _ requestInfo: Controller.RequestInfo) { onModifiedContent(content as Any, requestInfo) }
	
	public func onError (_ error: Controller.Error, _ requestInfo: Controller.RequestInfo) { onError(error, requestInfo) }
}
