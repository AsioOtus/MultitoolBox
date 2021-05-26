import Foundation

extension Controller {
	public enum Error: BaseNetworkUtil.Error {
		case preprocessingFailure(Swift.Error)
		case networkFailure(URLSession, URLRequest, URLError)
		case postprocessingFailure(Swift.Error)
		
		public var error: Swift.Error {
			let resultError: Swift.Error
			
			switch self {
			case .preprocessingFailure(let error): fallthrough
			case .postprocessingFailure(let error):
				resultError = error
			case .networkFailure(_, _, let error):
				resultError = error
			}
			
			return resultError
		}
		
		public init (_ error: Self) {
			if let innerError = error.error as? Self {
				self = innerError
			} else {
				self = error
			}
		}
	}
}
