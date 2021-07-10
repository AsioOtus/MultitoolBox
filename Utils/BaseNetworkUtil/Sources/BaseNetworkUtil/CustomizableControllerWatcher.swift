import Foundation

public struct CustomizableNetworkControllerWatcher: NetworkControllerWatcher {
	public var onRequest: (_ request: Request, _ requestInfo: NetworkController.RequestInfo) -> Void
	public var onUrlRequest: (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) -> Void
	public var onUrlResponse: (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) -> Void
	public var onResponse: (_ response: Response, _ requestInfo: NetworkController.RequestInfo) -> Void
	public var onContent: (_ content: Any, _ requestInfo: NetworkController.RequestInfo) -> Void
	
	public var onUnmodifiedRequest: (_ request: Request, _ requestInfo: NetworkController.RequestInfo) -> Void
	public var onUnmodifiedUrlRequest: (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) -> Void
	public var onModifiedUrlResponse: (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) -> Void
	public var onModifiedResponse: (_ response: Response, _ requestInfo: NetworkController.RequestInfo) -> Void
	public var onModifiedContent: (_ content: Any, _ requestInfo: NetworkController.RequestInfo) -> Void
	
	public var onError: (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo) -> Void
	
	
	
	public init (
		onRequest: @escaping (Request, NetworkController.RequestInfo) -> Void,
		onUrlRequest: @escaping (URLSession, URLRequest, NetworkController.RequestInfo) -> Void,
		onUrlResponse: @escaping (Data, URLResponse, NetworkController.RequestInfo) -> Void,
		onResponse: @escaping (Response, NetworkController.RequestInfo) -> Void,
		onContent: @escaping (Any, NetworkController.RequestInfo) -> Void,
		onUnmodifiedRequest: @escaping (Request, NetworkController.RequestInfo) -> Void,
		onUnmodifiedUrlRequest: @escaping (URLSession, URLRequest, NetworkController.RequestInfo) -> Void,
		onModifiedUrlResponse: @escaping (Data, URLResponse, NetworkController.RequestInfo) -> Void,
		onModifiedResponse: @escaping (Response, NetworkController.RequestInfo) -> Void,
		onModifiedContent: @escaping (Any, NetworkController.RequestInfo) -> Void,
		onError: @escaping (NetworkController.Error, NetworkController.RequestInfo) -> Void
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
	
	
	
	public func onRequest (_ request: Request, _ requestInfo: NetworkController.RequestInfo) { onRequest(request, requestInfo) }
	public func onUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) { onUrlRequest(urlSession, urlRequest, requestInfo) }
	public func onUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) { onUrlResponse(data, urlResponse, requestInfo) }
	public func onResponse (_ response: Response, _ requestInfo: NetworkController.RequestInfo) { onResponse(response, requestInfo) }
	public func onContent <Content> (_ content: Content, _ requestInfo: NetworkController.RequestInfo) { onContent(content as Any, requestInfo) }
	
	public func onUnmodifiedRequest (_ request: Request, _ requestInfo: NetworkController.RequestInfo) { onUnmodifiedRequest(request, requestInfo) }
	public func onUnmodifiedUrlRequest (_ urlSession: URLSession, _ urlRequest: URLRequest, _ requestInfo: NetworkController.RequestInfo) { onUnmodifiedUrlRequest(urlSession, urlRequest, requestInfo) }
	public func onModifiedUrlResponse (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: NetworkController.RequestInfo) { onModifiedUrlResponse(data, urlResponse, requestInfo) }
	public func onModifiedResponse (_ response: Response, _ requestInfo: NetworkController.RequestInfo) { onModifiedResponse(response, requestInfo) }
	public func onModifiedContent <Content> (_ content: Content, _ requestInfo: NetworkController.RequestInfo) { onModifiedContent(content as Any, requestInfo) }
	
	public func onError (_ error: NetworkController.Error, _ requestInfo: NetworkController.RequestInfo) { onError(error, requestInfo) }
}
