import Foundation

extension Controllers {
	public struct Logger {
        public static let module = "BaseNetworkUtil"
        
		private let loggingProvider: BaseNetworkUtilControllersLoggingProvider?
		public let source: String
		
		public init (_ source: String, _ loggingProvider: BaseNetworkUtilControllersLoggingProvider? = nil) {
			self.source = source
			self.loggingProvider = loggingProvider
		}
		
        func log <Request: BaseNetworkUtil.LoggableRequest> (_ request: Request) where Request.Response: LoggableResponse {
			loggingProvider?.baseNetworkUtilControllersLog(.init(.request(request), Self.module, source))
        }
        
		func log <Request: BaseNetworkUtil.LoggableRequest> (_ response: Request.Response, _ requestType: Request.Type) where Request.Response: LoggableResponse {
            loggingProvider?.baseNetworkUtilControllersLog(.init(Info<Request>.Category.response(response), Self.module, source))
        }
		
		func log <Request: BaseNetworkUtil.LoggableRequest> (_ error: BaseNetworkUtilError, _ requestType: Request.Type) where Request.Response: LoggableResponse {
            loggingProvider?.baseNetworkUtilControllersLog(.init(Info<Request>.Category.error(error), Self.module, source))
		}
	}
}



extension Controllers.Logger {
	public struct Info<Request: BaseNetworkUtil.LoggableRequest> where Request.Response: LoggableResponse {
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
            case response(Request.Response)
			case error(BaseNetworkUtilError)
			
			public func logMessage () -> String {
				let logMessage: String
				
				switch self {
				case .request(let request):
					logMessage = "REQUEST – \(request.logMessage())"
				case .response(let response):
					logMessage = "RESPONSE – \(response.logMessage())"
				case .error(let error as BaseNetworkError<Request>):
					switch error {
					case .preprocessingFailure(let error):
						logMessage = "REQUEST – PREPROCESSING ERROR – \(error)"
					case .responseFailure(let request, let error):
						logMessage = "RESPONSE – Request: \(request.logMessage()) – ERROR – \(error)"
					case .postprocessingError(let httpUrlResponse as HTTPURLResponse, let data, let error):
						logMessage = "RESPONSE – \(DefaultHTTPURLResponseStringConverter.default.convert(httpUrlResponse, body: data)) – POSTPROCESSING ERROR – \(error)"
					case .postprocessingError(let urlResponse, let data, let error):
						logMessage = "RESPONSE – \(DefaultURLResponseStringConverter.default.convert(urlResponse, body: data)) – POSTPROCESSING ERROR – \(error)"
					}
				case .error(let error):
					logMessage = "ERROR – " + error.localizedDescription
				}
				
				return logMessage
			}
		}
	}
}
