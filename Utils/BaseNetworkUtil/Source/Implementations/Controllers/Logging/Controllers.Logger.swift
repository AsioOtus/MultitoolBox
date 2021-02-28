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
			loggingProvider?.baseNetworkUtilControllersLog(.init(.request(.init(urlSession: urlSession, urlRequest: urlRequest)), "BaseNetworkUtil", source))
		}
		
		func log (_ data: Data, _ urlResponse: URLResponse) {
			loggingProvider?.baseNetworkUtilControllersLog(.init(.response(.init(data: data, urlResponse: urlResponse)), "BaseNetworkUtil", source))
		}
		
		func log (_ error: BaseNetworkUtilError) {
			loggingProvider?.baseNetworkUtilControllersLog(.init(.error(error), "BaseNetworkUtil", source))
		}
	}
}



extension Controllers.Logger {
	public struct Info {
		public let category: Category
		public let module: String
		public let source: String
		
		init (_ category: Category, _ module: String, _ source: String) {
			self.category = category
			self.module = module
			self.source = source
		}
		
		public enum Category {
			case request(Request)
			case response(Response)
			case error(BaseNetworkUtilError)
			
			public struct Request {
				let urlSession: URLSession
				let urlRequest: URLRequest
				
				var defaultMessage: String {
					"REQUEST – \(urlRequest.httpMethod ?? "Unknown method") \(urlRequest.url!.absoluteString)"
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
				case .error(let error as BaseNetworkError):
					switch error {
					case .preprocessingFailure(let error):
						defaultMessage = "PREPROCESSING ERROR – \(error)"
					case .responseFailure(_, let urlRequest, let error):
						defaultMessage = "RESPONSE – \(urlRequest.url!.absoluteString) – ERROR – \(error)"
					case .postprocessingError(let data, let urlResponse, let error):
						defaultMessage = "RESPONSE – \(urlResponse.url!.absoluteString) – \(data.base64EncodedString()) – POSTPROCESSING ERROR – \(error)"
					}
				case .error(let error):
					defaultMessage = "ERROR – " + error.localizedDescription
				}
				
				return defaultMessage
			}
		}
	}
}
