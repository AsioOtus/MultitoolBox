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
		
        func log <Request: BaseNetworkUtil.Request> (_ request: Request) {
            loggingProvider?.baseNetworkUtilControllersLog(.init(.request(request), "BaseNetworkUtil", source))
        }
        
        func log <Request: BaseNetworkUtil.Request> (_ response: Request.Response, _ requestType: Request.Type) {
            loggingProvider?.baseNetworkUtilControllersLog(.init(Info<Request>.Category.response(response), "BaseNetworkUtil", source))
        }
		
		func log <Request: BaseNetworkUtil.Request> (_ error: BaseNetworkUtilError, _ requestType: Request.Type) {
            loggingProvider?.baseNetworkUtilControllersLog(.init(Info<Request>.Category.error(error), "BaseNetworkUtil", source))
		}
	}
}



extension Controllers.Logger {
	public struct Info<RequestType: BaseNetworkUtil.Request> {
		public let category: Category
		public let module: String
		public let source: String
		
		init (_ category: Category, _ module: String, _ source: String) {
			self.category = category
			self.module = module
			self.source = source
		}
		
        public enum Category {
			case request(RequestType)
            case response(RequestType.Response)
			case error(BaseNetworkUtilError)
			
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
