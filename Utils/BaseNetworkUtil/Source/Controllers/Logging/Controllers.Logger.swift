import Foundation

extension Controllers {
	public struct Logger {
		private let loggingProvider: BaseNetworkUtilControllersLoggingProvider?
		public let source: String
		
		public init (_ source: String, _ loggingProvider: BaseNetworkUtilControllersLoggingProvider? = nil) {
			self.source = source
			self.loggingProvider = loggingProvider
		}
		
		func log (_ urlSession: URLSession, _ urlRequest: URLRequest) {
			loggingProvider?.baseNetworkUtilControllersLog(.init(source, .request(.init(urlSession: urlSession, urlRequest: urlRequest))))
		}
		
		func log (_ data: Data, _ urlResponse: URLResponse) {
			loggingProvider?.baseNetworkUtilControllersLog(.init(source, .response(.init(data: data, urlResponse: urlResponse))))
		}
		
		func log (_ error: BaseNetworkUtilError) {
			loggingProvider?.baseNetworkUtilControllersLog(.init(source, .error(error)))
		}
	}
}



extension Controllers.Logger {
	public struct Info {
		public let source: String
		public let category: Category
		
		init (_ source: String, _ category: Category) {
			self.source = source
			self.category = category
		}
		
		public enum Category {
			case request(Request)
			case response(Response)
			case error(BaseNetworkUtilError)
			
			public struct Request {
				let urlSession: URLSession
				let urlRequest: URLRequest
				
				var defaultMessage: String {
					"REQUEST – \(urlRequest.url!.absoluteString)"
				}
			}
			
			public struct Response {
				let data: Data
				let urlResponse: URLResponse
				
				var defaultMessage: String {
					"RESPONSE – \(urlResponse.url!.absoluteString)"
				}
			}
			
			public var defaultMessage: String {
				let defaultMessage: String
				
				switch self {
				case .request(let request):
					defaultMessage = request.defaultMessage
				case .response(let response):
					defaultMessage = response.defaultMessage
				case .error(let error):
					defaultMessage = error.localizedDescription
				}
				
				return defaultMessage
			}
		}
	}
}
