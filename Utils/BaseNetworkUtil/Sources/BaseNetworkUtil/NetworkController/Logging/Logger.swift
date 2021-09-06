import Foundation
import Combine

extension NetworkController {
	public class Logger {
		public var cancellables = Set<AnyCancellable>()
		
		public let onRequest = PassthroughSubject<LogRecord<Request>, Never>()
		public let onUrlRequest = PassthroughSubject<LogRecord<(urlSession: URLSession, urlRequest: URLRequest)>, Never>()
		public let onUrlResponse = PassthroughSubject<LogRecord<(data: Data, urlResponse: URLResponse)>, Never>()
		public let onResponse = PassthroughSubject<LogRecord<Response>, Never>()
		public let onContent = PassthroughSubject<LogRecord<Any>, Never>()
		
		public let onUnmodifiedRequest = PassthroughSubject<LogRecord<Request>, Never>()
		public let onUnmodifiedUrlRequest = PassthroughSubject<LogRecord<(urlSession: URLSession, urlRequest: URLRequest)>, Never>()
		public let onModifiedUrlResponse = PassthroughSubject<LogRecord<(data: Data, urlResponse: URLResponse)>, Never>()
		public let onModifiedResponse = PassthroughSubject<LogRecord<Response>, Never>()
		public let onModifiedContent = PassthroughSubject<LogRecord<Any>, Never>()
		
		public let onError = PassthroughSubject<LogRecord<NetworkController.Error>, Never>()
		
		public init () { }
	}
}

extension NetworkController.Logger {
	@discardableResult
	public func onRequest (_ action: @escaping (LogRecord<Request>) -> ()) -> Self {
		onRequest.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onUrlRequest (_ action: @escaping (LogRecord<(urlSession: URLSession, urlRequest: URLRequest)>) -> ()) -> Self {
		onUrlRequest.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onUrlResponse (_ action: @escaping (LogRecord<(data: Data, urlResponse: URLResponse)>) -> ()) -> Self {
		onUrlResponse.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onResponse (_ action: @escaping (LogRecord<Response>) -> ()) -> Self {
		onResponse.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onContent (_ action: @escaping (LogRecord<Any>) -> ()) -> Self {
		onContent.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	
	
	@discardableResult
	public func onUnmodifiedRequest (_ action: @escaping (LogRecord<Request>) -> ()) -> Self {
		onUnmodifiedRequest.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onUnmodifiedUrlRequest (_ action: @escaping (LogRecord<(urlSession: URLSession, urlRequest: URLRequest)>) -> ()) -> Self {
		onUnmodifiedUrlRequest.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onModifiedUrlResponse (_ action: @escaping (LogRecord<(data: Data, urlResponse: URLResponse)>) -> ()) -> Self {
		onModifiedUrlResponse.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onModifiedResponse (_ action: @escaping (LogRecord<Response>) -> ()) -> Self {
		onModifiedResponse.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onModifiedContent (_ action: @escaping (LogRecord<Any>) -> ()) -> Self {
		onModifiedContent.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	
	
	@discardableResult
	public func onError (_ action: @escaping (LogRecord<NetworkController.Error>) -> ()) -> Self {
		onError.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
}
